//
//  CharacterStore.swift
//  CharacterStore
//
//  Created by Kasumigaoka Utaha on 14.08.21.
//

import Foundation
import UIKit

struct CharacterStore {
    static let shared = CharacterStore()

    private var characters: [Character]

    init() {
        characters = []
        // TODO: replace hardcoded character_table.json file with dynamic one that matches the currently chosen game region
        guard let asset = NSDataAsset(name: "character_table.json") else {
            fatalError("Missing data asset: character_table.json")
        }
        guard let characterTables = try? JSONSerialization.jsonObject(
            with: asset.data,
            options: .mutableContainers
        ) as? [String: Any]
        else {
            fatalError("Could not parse contents of data asset: character_table.json as json")
        }

        let decoder = JSONDecoder()
        for key in characterTables.keys {
            guard key.hasPrefix("char") else {
                continue
            }
            guard let data = try? JSONSerialization.data(withJSONObject: characterTables[key]!) else {
                fatalError("Could not convert parsed data into JSON Object")
            }

            do {
                let character = try decoder.decode(Character.self, from: data)
                characters.append(character)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
    }

    func getCharacters() -> [Character] {
        characters
    }

    func getAllProfessions() -> [String] {
        Array(Set(characters.map(\.profession)))
    }

    func getAllSubProfessions() -> [String] {
        Array(Set(characters.map(\.subProfessionId)))
    }
}
