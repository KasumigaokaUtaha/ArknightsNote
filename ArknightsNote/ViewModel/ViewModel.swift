//
//  ViewModel.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 17.05.21.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var chosenTags: [String] = []
    @Published var recruitTagsToChars: [[String]:[Character]] = [:]
    
    let characterStore: CharacterStore = CharacterStore()
    
    func validate(tag: String) -> Bool {
        return RecruitCategory.all.contains(tag)
    }
    
    func computeCharactersMatchedWith(tags: [String], maxTagCombCnt: Int = 4) {
        DispatchQueue.main.async {
            self.recruitTagsToChars = self.characterStore.computeCharactersMatchedWith(tags: tags, maxTagCombCnt: maxTagCombCnt)
        }
    }
}
