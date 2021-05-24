//
//  RecruitTagCloud.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 18.05.21.
//

import SwiftUI

struct RecruitTagCloud<Content: View>: View {
    var tags: [String]
    var spacing: CGFloat = 4.0
    var alignment: HorizontalAlignment = .center
    var content: (String) -> Content
    
//    @Binding var chosenTags: [String]

    var body: some View {
        FlexibleView(data: tags, spacing: spacing, alignment: alignment, content: { tag in
            content(tag)
//            Text(tag)
//                .foregroundColor(.white)
//                .padding(.vertical, 4)
//                .padding(.horizontal, 8)
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill()
//                        .foregroundColor(
//                            chosenTags.contains(tag) ? .blue : .gray
//                        )
//                )
//                .onTapGesture {
//                    if let index = chosenTags.firstIndex(of: tag) {
//                        chosenTags.remove(at: index)
//                    } else {
//                        chosenTags.append(tag)
//                    }
//                }
        })
    }
}

struct RecruitTagCloud_Previews: PreviewProvider {
    static var viewModel = ViewModel()
    @State static var chosenTags: [String] = []

    static var previews: some View {
        RecruitTagCloud(tags: viewModel.category.trait, alignment: .center) { tag in
            Text(tag)
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill()
                        .foregroundColor(.gray)
                )
        }
    }
}
