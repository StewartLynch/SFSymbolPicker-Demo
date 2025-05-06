//
//----------------------------------------------
// Original project: SFSymbolPicker Demo
// by  Stewart Lynch on 2025-05-06
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

struct SymbolView: View {
    @Environment(\.dismiss) var dismiss
    let loader: SymbolLoader
    @Binding var selectedSymbol: String
    let limitedCategories: [CategoryEnum]
    let searchTerm: String
    @State private var selectedCategory: String
    @State private var searchText: String
    
    init(
        loader: SymbolLoader,
        selectedSymbol: Binding<String>,
        limitedCategories: [CategoryEnum] = [],
        searchTerm: String = "",
    ) {
        self.loader = loader
        self._selectedSymbol = selectedSymbol
        self.limitedCategories = limitedCategories
        self.searchTerm = searchTerm
        let initialCategory = limitedCategories.count == 1 ? limitedCategories.first!.rawValue : "All Categories"
        self._selectedCategory = State(initialValue: initialCategory)
        self._searchText = State(initialValue: searchTerm)
    }
    var availableCategories: [Category] {
        loader.availableCategories(limitedCategories: limitedCategories)
    }
    var body: some View {
        var filteredSymbols: [Symbol] {
            loader.symbols
                .filter { symbol in
                    if !limitedCategories.isEmpty {
                        let allowedKeys = Set(limitedCategories.map { $0.rawValue })
                        return symbol.categories.contains {
                            allowedKeys.contains($0.key)
                        }
                    }
                    return true
                }
                .filter { symbol in
                    selectedCategory == "All Categories" ||
                    symbol.categories.contains(where: {$0.key == selectedCategory})
                }
                .filter { symbol in
                    searchText.isEmpty ||
                    symbol.name.localizedCaseInsensitiveContains(searchText) ||
                    symbol.searchTerms.contains {
                        $0.localizedCaseInsensitiveContains(searchText)
                    }
                }
        }
        let columns = [GridItem(.adaptive(minimum: 50))]
        VStack(alignment: .leading) {
            if !(limitedCategories.count == 1 || !searchTerm.isEmpty) {
                Picker("Categories", selection: $selectedCategory) {
                    Label("All Categories", systemImage: "square.grid.2x2").tag("All Categories")
                    ForEach(availableCategories, id: \.key) { category in
                        Label(category.label, systemImage: category.icon).tag(category.key)
                    }
                }
                .buttonStyle(.bordered)
            }
            if searchTerm.isEmpty {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search...", text: $searchText)
                        .autocapitalization(.none)
                        .textFieldStyle(.plain)
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(6)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.secondarySystemBackground))
                }
            }
        }
        .padding()
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(filteredSymbols, id: \.name) { symbol in
                    Button {
                        selectedSymbol = symbol.name
                        dismiss()
                    } label: {
                        Image(systemName: symbol.name)
                            .font(.system(size: 22))
                    }
                    .buttonStyle(.plain)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(symbol.name == selectedSymbol ? Color(.secondarySystemFill) : .clear)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SymbolView(loader: SymbolLoader(), selectedSymbol: .constant("plus.circle.fill"))
}
