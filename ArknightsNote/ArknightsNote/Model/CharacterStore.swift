//
//  CharacterStore.swift
//  CharacterStore
//
//  Created by Kasumigaoka Utaha on 14.08.21.
//

import Foundation

struct CharacterStore {
    
    private var characters: [Character]

    init() {
        let url = Bundle.main.url(forResource: "character_table", withExtension: "json")
        guard let url = url else {
            fatalError("Could not find the resource file character_table.json")
        }
        
        characters = []
        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load contents of \(url)")
        }
        
        guard let char_dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
            fatalError("Could not parse contents of \(url) as json")
        }
        
        for value in char_dict.values {
            guard let json_value = try? JSONSerialization.data(withJSONObject: value) else {
                fatalError("Could not convert parsed data into JSON Object")
            }
            
            if let char = try? decoder.decode(Character.self, from: json_value) {
                characters.append(char)
            }
        }
    }
    
    func getCharacters() -> [Character] {
        return characters
    }
}
