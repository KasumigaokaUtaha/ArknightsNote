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
}
