//
//  RecruitmentItem.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 16.05.21.
//

import SwiftUI

struct RecruitItem: View {
    let name: String
    let rarity: Rarity
    let profession: Profession
    
    enum Rarity: String {
        case rare = "资深干员"
        case superRare = "6★"
    }
    
    enum Profession: String {
        case sniper = "狙击"
    }
    
    var body: some View {
        VStack {
            Image("illustr_Schwarz")
                .resizable()
                .frame(width: 125, height: 125)
                .cornerRadius(5)
            HStack {
                Text(rarity.rawValue)
                Text(name)
                Text(profession.rawValue)
            }
            .font(.caption)
        }
    }
}

struct RecruitmentItem_Previews: PreviewProvider {
    static var previews: some View {
        RecruitItem(name: "Schwarz", rarity: .superRare, profession: .sniper)
    }
}
