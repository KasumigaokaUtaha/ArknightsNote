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
    
    var recruitRequirement: some View {
        VStack {
            HStack {
                TextField("招募需求", text: $requirement, onCommit: {
                    if viewModel.validate(tag: requirement), !chosenTags.contains(requirement), chosenTags.count < 4 {
                        chosenTags.append(requirement)
                        viewModel.computeCharactersMatchedWith(tags: chosenTags)
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
            RecruitTagCloud(tags: chosenTags, spacing: 8.0, alignment: .leading, content: { tag in
                HStack {
                    Text(tag)
                    Image(systemName: "xmark.circle")
                        .onTapGesture {
                            if let tagIndex = chosenTags.firstIndex(of: tag) {
                                chosenTags.remove(at: tagIndex)
                                viewModel.computeCharactersMatchedWith(tags: chosenTags)
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
    }
    
    var recruitMatchResult: some View {
        ScrollView {
            ForEach(viewModel.recruitTagsToChars.sorted { $0.key.count > $1.key.count }, id: \.key) { tags, chars in
                Divider()
                HStack {
                    FlexibleView(data: tags, spacing: 4.0, alignment: .leading) { tag in
                        Text(tag)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill()
                                    .foregroundColor(.gray)
                                    .opacity(0.4)
                            )
                    }
                }
                FlexibleView(data: chars, spacing: 4.0, alignment: .leading) { char in
                        Text(char.name)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill()
                                    .foregroundColor(.gray)
                                    .opacity(0.4)
                            )
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                recruitRequirement
                Spacer()
                recruitMatchResult
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
