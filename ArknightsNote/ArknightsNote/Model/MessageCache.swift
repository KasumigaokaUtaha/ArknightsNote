//
//  MessageCache.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.11.21.
//

import Foundation

class MessageCache {
    @Published private(set) var elements: [Message]

    init() {
        elements = []
    }

    init(elements: [Message]) {
        self.elements = elements
    }

    // MARK: - Getters

    func getElements() -> [Message] {
        elements
    }

    // MARK: - Setters

    func setElements(_ newElements: [Message]) {
        elements = newElements
    }

    // MARK: - Operators

    func append(_ element: Message) {
        elements.append(element)
    }

    private func computeMergedElements(with newElements: [Message]) -> [Message] {
        var dict: [Date: Message] = [:]
        newElements.forEach { dict.updateValue($0, forKey: $0.date) }
        elements.forEach { dict.updateValue($0, forKey: $0.date) }
        return Array(dict.values)
    }

    func merge(with newElements: [Message]) {
        // TODO: add another parameter: on key: KeyPath<...>
        elements = computeMergedElements(with: newElements)
    }

    func sort(by areInIncreasingOrder: (Message, Message) throws -> Bool) rethrows {
        try elements.sort(by: areInIncreasingOrder)
    }

    func merge(with newElements: [Message], sortBy areInIncreasingOrder: (Message, Message) throws -> Bool) rethrows {
        let mergedElements = computeMergedElements(with: newElements)
        elements = try mergedElements.sorted(by: areInIncreasingOrder)
    }

    func removeAll() {
        elements.removeAll()
    }

    // MARK: - Storage Operators

    func writeCache(to directory: FileManager.SearchPathDirectory, fileName: String) {
        do {
            try FileHelper.writeJSON(elements, to: directory, fileName: fileName)
        } catch {
            logger.debug("\(error.localizedDescription)", metadata: nil, source: "\(#file).\(#function)")
        }
    }
}
