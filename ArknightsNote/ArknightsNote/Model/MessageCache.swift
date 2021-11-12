//
//  MessageCache.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.11.21.
//

import Foundation

class MessageCache {
    private var elements: [Message]
    
    init() {
        self.elements = []
    }
    
    init(elements: [Message]) {
        self.elements = elements
    }
    
    func append(_ element: Message) {
        elements.append(element)
    }
    
    func getElements() -> [Message] {
        return elements
    }
    
    func merge(with newElements: [Message]) {
        // TODO add another parameter: on key: KeyPath<...>
        var dict: [Date : Message] = [:]
        newElements.forEach { dict.updateValue($0, forKey: $0.date) }
        elements.forEach { dict.updateValue($0, forKey: $0.date) }
        elements = Array(dict.values)
    }
    
    func sort(by areInIncreasingOrder: (Message, Message) throws -> Bool) rethrows {
        try elements.sort(by: areInIncreasingOrder)
    }
    
    func removeAll() {
        elements.removeAll()
    }
    
    func writeCache(to directory: FileManager.SearchPathDirectory, fileName: String) {
        do {
            try FileHelper.writeJSON(elements, to: directory, fileName: fileName)
        } catch {
            logger.debug("\(error.localizedDescription)", metadata: nil, source: "\(#file).\(#function)")
        }
    }
}
