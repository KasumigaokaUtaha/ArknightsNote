//
//  RecruitmentLogicController.swift
//  RecruitmentLogicController
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import Foundation

class RecruitmentLogicController {
    
    // MARK: - Properties

    private let characterStore: CharacterStore
    private let recruitmentStore: RecruitmentStore
    private lazy var tagToChars: [String: [Character]] = {
        let recruitmentCharacterNames = recruitmentStore.getRecruitmentCharacterNames()
        let recruitmentCharacters = characterStore.getCharacters().filter { character in
            return recruitmentCharacterNames.contains(character.name)
        }
        
        var tagToChars = [String: [Character]]()
        
        for character in recruitmentCharacters {
            var tagList = character.tagList
            tagList.append(contentsOf: [
                recruitmentStore.tagWithCategory(.seniority, value: character.rarity),
                recruitmentStore.tagWithCategory(.position, value: character.position),
                recruitmentStore.tagWithCategory(.profession, value: character.profession)
            ])

            for tag in tagList {
                var chars = tagToChars[tag] ?? [Character]()
                chars.append(character)
                tagToChars.updateValue(chars, forKey: tag)
            }
        }
        
        return tagToChars
    }()
    
    // MARK: - Initializers

    init() {
        characterStore = CharacterStore()
        recruitmentStore = RecruitmentStore()
    }
    
    // MARK: - Logic

    func computeCharactersWithCombinationsOf(tags chosenTags: [String], maxTagsCount: Int = 4) -> [[String]:[Character]] {
        var result = [[String]: [Character]]()
        
        var currentTagsToChars = [[String]: [Character]]()
        for chosenTag in chosenTags {
            if let chars = self.tagToChars[chosenTag] {
                currentTagsToChars.updateValue(chars, forKey: [chosenTag])
                result.updateValue(chars, forKey: [chosenTag]) // Merge initial TagsToChars
            } else {
                print("Unknown tag: \(chosenTag)")
            }
        }
        
        for _ in 1..<maxTagsCount {
            var nextTagsToChars = [[String]: [Character]]()
            let currentTags = Array(currentTagsToChars.keys)
            
            for i in 0..<currentTags.count {
                let iTags = currentTags[i]
                let iChars = currentTagsToChars[iTags]!

                for j in i+1..<currentTags.count {
                    let jTags = currentTags[j]
                    let jChars = currentTagsToChars[jTags]!
                    
                    if Set(iChars).isDisjoint(with: Set(jChars)) {
                        continue
                    }
                    
                    let nextChars = Array(Set(iChars).intersection(Set(jChars)))
                    
                    if iTags.count == 1 && jTags.count == 1 {
                        nextTagsToChars.updateValue(nextChars, forKey: iTags + jTags)
                    } else {
                        let nextTagsCount = iTags.count + 1
                        
                        let nextTags = Array(Set(iTags).intersection(Set(jTags)))
                        if nextTags.count != nextTagsCount {
                            continue
                        }
                        
                        nextTagsToChars.updateValue(nextChars, forKey: nextTags)
                    }
                }
            }
            
            for (tags, chars) in nextTagsToChars {
                result.updateValue(chars, forKey: tags)
            }
            currentTagsToChars = nextTagsToChars
        }
        
        return result
    }
}
