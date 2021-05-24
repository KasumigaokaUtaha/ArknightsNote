//
//  RecruitmentTagSheet.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 16.05.21.
//

import SwiftUI

struct RecruitTagSheet: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var chosenTags: [String]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                RecruitTagCategory(
                    header: "资质",
                    tags: viewModel.category.seniority,
                    chosenTags: $chosenTags
                )
                RecruitTagCategory(
                    header: "位置",
                    tags: viewModel.category.position,
                    chosenTags: $chosenTags
                )
                RecruitTagCategory(
                    header: "职业",
                    tags: viewModel.category.profession,
                    chosenTags: $chosenTags
                )
                RecruitTagCategory(
                    header: "特性",
                    tags: viewModel.category.trait,
                    chosenTags: $chosenTags
                )
                Spacer()
            }
            .padding(.horizontal, 8)
            .navigationTitle(Text("招募需求"))
        }
    }
}

struct RecruitTagCategory: View {
    let header: String
    let tags: [String]

    @EnvironmentObject var viewModel: ViewModel
    @Binding var chosenTags: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.subheadline)
            RecruitTagCloud(tags: tags, spacing: 8.0, alignment: .leading) { tag in
            Text(tag)
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill()
                        .foregroundColor(
                            chosenTags.contains(tag) ? .blue : .gray
                        )
                )
                .onTapGesture {
                    if let index = chosenTags.firstIndex(of: tag) {
                        chosenTags.remove(at: index)
                    } else {
                        chosenTags.append(tag)
                    }
                }
            }
        }
    }
    
//    func tapTag(_ tag: String) {
//        if viewModel.chosenTags.contains(tag) {
//            guard let tagIndex = viewModel.chosenTags.firstIndex(of: tag) else { return }
//            viewModel.chosenTags.remove(at: tagIndex)
//        } else {
//            viewModel.chosenTags.append(tag)
//        }
//    }
}

//struct RecruitmentTag: View {
//    @EnvironmentObject var viewModel: ViewModel
//
//    let tag: String
//    var isChosen: Bool {
//        viewModel.chosenTags.contains(tag)
//    }
//
//    var body: some View {
//        Text(tag)
//            .foregroundColor(.white)
//            .padding(.vertical, 4)
//            .padding(.horizontal, 8)
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill()
//                    .foregroundColor(
//                        isChosen ? .blue : .gray
//                    )
//            )
//    }
//}

struct RecruitmentTagSheet_Previews: PreviewProvider {
    @State static var tags = ["控场", "爆发", "治疗", "支援", "费用回复", "输出", "生存", "群攻", "防护", "减速", "削弱", "快速复活", "位移", "召唤", "支援机械"]

    static var previews: some View {
        RecruitTagSheet(chosenTags: $tags)
            .environmentObject(ViewModel())
    }
}
