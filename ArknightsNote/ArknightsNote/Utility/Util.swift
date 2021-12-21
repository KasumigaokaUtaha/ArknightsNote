//
//  Util.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 21.11.21.
//

import Kanna
import Foundation

enum Util {
    static func extractText(from html: String) -> String? {
        return (try? Kanna.HTML(html: html, encoding: .utf8))?.text
    }
    
    /// Computes and extracts the range of XML elements and element contents.
    ///
    /// This function returns a dictionary that contains the range of a XML element as key and the range of a XML element content as value.
    static func extractXMLElementRange(from text: String, with pattern: String) -> [Range<String.Index> : Range<String.Index>] {
        var ranges = [Range<String.Index> : Range<String.Index>]()

        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsRange = NSRange(text.startIndex ..< text.endIndex, in: text)
            regex.enumerateMatches(in: text, options: [], range: nsRange) { (match, _, stop) in
                guard
                    let match = match,
                    let xmlElementCaptureRange = Range(match.range(at: 1), in: text),
                    let xmlElementContentCaptureRange = Range(match.range(at: 2), in: text)
                else {
                    return
                }
                
                ranges[xmlElementCaptureRange] = xmlElementContentCaptureRange
            }
        } catch {
            print("failed to build regex for pattern: \(pattern)")
        }
        
        return ranges
    }
    
    /// Computes and extracts XML element content from given text and the given pattern is used to recognize an XML element.
    ///
    /// This function returns a tuple where the first element is a String with all XML tags removed, and the second element contains the range of each XML element content in the first element of the returned tuple.
    static func extractXMLContent(from text: String, with pattern: String) -> (String, [Range<String.Index>]) {
        let ranges = extractXMLElementRange(from: text, with: pattern)
        
        var textSegments = [String]()
        var isXMLContent = [Bool]()
        var startIndex = text.startIndex
        for range in ranges.keys.sorted(by: { $0.lowerBound < $1.lowerBound }) {
            if startIndex < range.lowerBound {
                textSegments.append(String(text[startIndex ..< range.lowerBound]))
                isXMLContent.append(false)
            }

            let contentRange = ranges[range]! // contentRange = text[range.lowerBound, range.upperBound)
            textSegments.append(String(text[contentRange]))
            isXMLContent.append(true)
            
            startIndex = range.upperBound // text[range.upperBound] is not handled yet
        }
        if startIndex < text.endIndex {
            textSegments.append(String(text[startIndex ..< text.endIndex]))
            isXMLContent.append(false)
        }
        
        var extractedXMLContent = textSegments.joined(separator: "")
        while let rangeOfNewLine = extractedXMLContent.range(of: "\\n") {
            extractedXMLContent.replaceSubrange(rangeOfNewLine, with: "\n")
        }
        var xmlContentRanges = [Range<String.Index>]()
        for i in 0 ..< textSegments.count {
            if isXMLContent[i] {
                let xmlContent = textSegments[i]
                xmlContentRanges.append(extractedXMLContent.range(of: xmlContent)!)
            }
        }
        
        return (extractedXMLContent, xmlContentRanges)
    }
}
