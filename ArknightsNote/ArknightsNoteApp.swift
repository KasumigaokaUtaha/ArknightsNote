//
//  ArknightsNoteApp.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 18.05.21.
//

import SwiftUI

@main
struct ArknightsNoteApp: App {
    var body: some Scene {
        WindowGroup {
            RecruitHome()
                .environmentObject(ViewModel())
        }
    }
}
