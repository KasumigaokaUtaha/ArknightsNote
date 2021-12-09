//
//  CharacterStore.swift
//  CharacterStore
//
//  Created by Kasumigaoka Utaha on 14.08.21.
//

import UIKit
import Foundation

struct CharacterStore {
    
    private var characters: [Character]

    init() {
        characters = []
        guard let asset = NSDataAsset(name: "character_table.json") else {
            fatalError("Missing data asset: character_table.json")
        }
        guard let characterTables = try? JSONSerialization.jsonObject(with: asset.data, options: .mutableContainers) as? [String:Any] else {
            fatalError("Could not parse contents of data asset: character_table.json as json")
        }
        
        let decoder = JSONDecoder()
        for key in characterTables.keys {
            guard key.hasPrefix("char") else { continue }
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
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
    }
    
    func getCharacters() -> [Character] {
        return characters
    }
}
