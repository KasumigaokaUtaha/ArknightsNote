//
//  ViewModel.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 17.05.21.
//

import SwiftUI

class ViewModel: ObservableObject {
    let category: RecruitCategory = RecruitCategory()
    
    @Published var chosenTags: [String] = []
    
    func validate(tag: String) -> Bool {
        return category.all.contains(tag)
    }
}
