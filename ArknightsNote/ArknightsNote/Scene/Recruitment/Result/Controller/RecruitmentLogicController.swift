//
//  RecruitmentLogicController.swift
//  RecruitmentLogicController
//
//  Created by Kasumigaoka Utaha on 13.08.21.
//

import Foundation

class RecruitmentLogicController {
    
    // MARK: - Properties

    private let recruitmentStore: RecruitmentStore
    private lazy var tagToChars: [String: [Character]] = {
        let recruitmentCharacterNames = recruitmentStore.getRecruitmentCharacterNames()
        let recruitmentCharacters = CharacterStore.shared.getCharacters().filter { character in
            return recruitmentCharacterNames.contains(character.name)
        }
        
        var tagToChars = [String: [Character]]()
        
        for character in recruitmentCharacters {
            var tagList = character.tagList
            
            [recruitmentStore.tagOfCategory(.seniority, value: character.rarity),
             recruitmentStore.tagOfCategory(.position, value: character.position),
             recruitmentStore.tagOfCategory(.profession, value: character.profession)].forEach { element in
                if let element = element {
                    tagList.append(element)
                }
            }

            for tag in tagList {
                var chars = tagToChars[tag] ?? [Character]()
                if !chars.contains(character) { chars.append(character) }
                tagToChars.updateValue(chars, forKey: tag)
            }
        }
        
        return tagToChars
    }()
    
    // MARK: - Initializers

    init() {
        recruitmentStore = RecruitmentStore()
    }
    
    // MARK: - Logic

    func computeCharactersWith(tags chosenTags: [String], maxTagsCount: Int = 4) -> [[String]: [Character]] {
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
