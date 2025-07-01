//
//----------------------------------------------
// Original project: SFSymbolPicker Demo
// by  Stewart Lynch on 2025-05-05
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2025 CreaTECH Solutions. All rights reserved.


import SwiftUI

struct ContentView: View {
    // Default images
    @State private var allCategoriesImage = "square.grid.2x2"
    @State private var singleCategoryImage = "person.crop.circle"
    @State private var mixedCategoriesImage = "bicycle"
    @State private var searchTermImage = "figure.cooldown"
    // Presentation Triggers
    @State private var showAll = false
    @State private var showSingle = false
    @State private var showMixed = false
    @State private var showSearchTerm = false
    
    @State private var loader = SymbolLoader()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text(
"""
SymbolView(
    loader: loader, // SymbolLoader instance
    selectedSymbol: $allCategoriesImage
)
"""
                        )
                        .font(.system(size: 12))
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundStyle(.secondary)
                        Button {
                            showAll = true
                        } label: {
                            Image(systemName: allCategoriesImage)
                        }
                        .foregroundStyle(.red)
                        .font(.largeTitle)
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .sheet(isPresented: $showAll) {
                        SymbolView(loader: loader, selectedSymbol: $allCategoriesImage)
                    }
                } header: {
                    Text("All Categories Available")
                }
                Section {
                    HStack{
                        Text(
"""
SymbolView(
    loader: loader, // SymbolLoader instance
    selectedSymbol: $singleCategoryImage,
    limitedCategories: [.human]
)
""")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: true, vertical: false)
                        Spacer()
                        Button {
                            showSingle = true
                        } label: {
                            Image(systemName: singleCategoryImage)
                        }
                        .foregroundStyle(.green)
                        .font(.largeTitle)
                        .buttonStyle(.plain)
                        .popover(isPresented: $showSingle) {
                            SymbolView(
                                loader: loader,
                                selectedSymbol: $singleCategoryImage,
                                limitedCategories: [.human]
                            )
                            .frame(width: 300, height: 300)
                            .presentationCompactAdaptation(.popover)
                        }
                    }
                } header: {
                    Text("Single Category Available")
                }
                Section {
                    HStack{
                        Text(
"""
SymbolView(
    loader: loader, // SymbolLoader instance
    selectedSymbol: $mixedCategoriesImage,
    limitedCategories: [
          .transportation, 
          .objectsandtools
    ]
)
""")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: true, vertical: false)
                        Spacer()
                        Button {
                            showMixed = true
                        } label: {
                            Image(systemName: mixedCategoriesImage)
                        }
                        .foregroundStyle(.blue)
                        .font(.largeTitle)
                        .buttonStyle(.plain)
                    }
                    .sheet(isPresented: $showMixed) {
                        SymbolView(
                            loader: loader,
                            selectedSymbol: $mixedCategoriesImage,
                            limitedCategories: [.transportation, .objectsandtools]
                        )
                        .presentationDetents([.medium])
                    }
                } header: {
                    Text("Multiple Categories Only")
                }
                Section {
                    HStack{
                        Text(
"""
SymbolView(
    loader: loader, // SymbolLoader instance
    selectedSymbol: $searchTermImage,
    searchTerm: "sport"
)
""")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: true, vertical: false)
                        Spacer()
                        Button {
                            showSearchTerm = true
                        } label: {
                            Image(systemName: searchTermImage)
                        }
                        .foregroundStyle(.purple)
                        .font(.largeTitle)
                        .buttonStyle(.plain)
                        .popover(isPresented: $showSearchTerm) {
                            SymbolView(
                                loader: loader,
                                selectedSymbol: $searchTermImage,
                                searchTerm: "sport"
                            )
                            .frame(width: 300, height: 300)
                            .presentationCompactAdaptation(.popover)
                        }
                    }
                } header: {
                    Text("Search Term only")
                }
            }
            .navigationTitle("SF Symbol Picker")
        }
//        .onAppear {
//            let categories = loader.categories.map {$0.key}
//            let cases = categories.joined(separator: ", ")
//            print(cases)
//        }
    }
}

#Preview {
    ContentView()
}
