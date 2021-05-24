//
//  ContentView.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 18.05.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("当前选中的标签")) {
                    Text("Hello world")
                    Button(action: {}, label: {
                        Text("Button")
                    })
                }
                Section(header: Text("狙击 ")) {
                    HStack {
                        Image(systemName: "note.text")
                        Spacer()
                        VStack {
                            Text("能天使")
                            HStack {
                                Text("6 星")
                                Text("狙击")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("公共招募"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

