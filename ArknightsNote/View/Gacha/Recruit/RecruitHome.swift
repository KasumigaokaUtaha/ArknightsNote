//
//  RecruitmentHome.swift
//  Arknights-Notes
//
//  Created by Kasumigaoka Utaha on 16.05.21.
//

import SwiftUI

struct RecruitHome: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingSheet = false
    @State private var requirement: String = ""
    @State var chosenTags: [String] = []

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        TextField("招募需求", text: $requirement, onCommit: {
                            if viewModel.validate(tag: requirement) && !chosenTags.contains(requirement) {
                                chosenTags.append(requirement)
                            }
                        })
                        Spacer()
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.title2)
                            .onTapGesture {
                                showingSheet.toggle()
                            }
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill()
                            .foregroundColor(.gray)
                            .opacity(0.2)
                            .padding(.horizontal, 8)
                    )
                    
                    // chosen tags
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack {
//                            ForEach(viewModel.chosenTags, id: \.self) { tag in
//                                HStack {
//                                    Text(tag)
//                                    Image(systemName: "xmark.circle")
//                                        .onTapGesture {
//                                            if let tagIndex = viewModel.chosenTags.firstIndex(of: tag) {
//                                                viewModel.chosenTags.remove(at: tagIndex)
//                                            }
//                                        }
//                                }
//                                .foregroundColor(.white)
//                                .padding(.vertical, 4)
//                                .padding(.horizontal, 8)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill()
//                                        .foregroundColor(.blue)
//                                )
//                            }
//                        }
//                    }
                    RecruitTagCloud(tags: chosenTags, spacing: 8.0, alignment: .leading, content: { tag in
                        HStack {
                            Text(tag)
                            Image(systemName: "xmark.circle")
                                .onTapGesture {
                                    if let tagIndex = chosenTags.firstIndex(of: tag) {
                                        chosenTags.remove(at: tagIndex)
                                    }
                                }
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill()
                                .foregroundColor(.blue)
                        )
                    })
                    .padding(.horizontal, 8)
                }
                
//                Color.clear
//                    .frame(height: 30)
//                Spacer()
//                    .frame(height: 80)
                
//                VStack {
//                    // 现在存在一个问题
//                    // 使用 List 这个容器视图时，如果在其中一个 cell 里放入了可以点击的视图，
//                    // 那么整个 cell 都会变成可以点击的。
//                    ForEach(0..<3, id: \.self) { _ in
//                        RecruitRow(selectedTags: ["资深干员", "爆发", "狙击"])
//                    }
//                }
                Spacer()
            }
            .sheet(isPresented: $showingSheet) {
                RecruitTagSheet(chosenTags: $chosenTags)
            }
            .navigationTitle(Text("公开招募"))
        }
    }
}

struct RecruitmentHome_Previews: PreviewProvider {
    static var previews: some View {
        RecruitHome()
            .environmentObject(ViewModel())
    }
}
