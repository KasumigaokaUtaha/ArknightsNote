//
//  RecruitmentRow.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 16.05.21.
//

import SwiftUI

struct RecruitRow: View {
    let selectedTags: [String]
    let data = [
        RecruitItem(name: "Schwarz", rarity: .superRare, profession: .sniper),
        RecruitItem(name: "Schwarz", rarity: .superRare, profession: .sniper),
        RecruitItem(name: "Schwarz", rarity: .superRare, profession: .sniper)
    ]
    let columns = [ GridItem(.adaptive(minimum: 125)) ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0..<selectedTags.count, id: \.self) { index in
                    Text(selectedTags[index])
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill()
                                .foregroundColor(.blue)
                        )
                }
            }
            LazyVGrid(columns: columns) {
                ForEach(0..<data.count, id: \.self) { index in
                    data[index]
                }
            }
        }
    }
}

struct RecruitmentRow_Previews: PreviewProvider {
    static var previews: some View {
        RecruitRow(selectedTags: ["资深干员", "爆发", "狙击"])
    }
}
