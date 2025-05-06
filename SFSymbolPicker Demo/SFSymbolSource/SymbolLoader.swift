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


import Foundation

@Observable
class SymbolLoader {
    var categories: [Category] = []
    var symbols: [Symbol] = []
    
    init() {
        buildSymbolsArray()
    }
    
    
    func buildSymbolsArray() {
        categories = decodePlist([Category].self, from: "categories")
            .sorted(using: KeyPathComparator(\.key))
            .filter { $0.key != "all"}
        categories.insert(Category.uncategorized, at: 0)
        let symbolCategoriesDict = decodePlist([String : [String]].self, from: "symbol_categories")
        let symbolSearchTermsDict = decodePlist([String : [String]].self, from: "symbol_search")
        let symbolAvailability = decodePlist(Symbol_Availability.self, from: "name_availability")
        for (name, releaseYear) in symbolAvailability.symbols {
            let symbolCategoriesNames = symbolCategoriesDict[name] ?? []
            var symbolCategories = symbolCategoriesNames.compactMap({ name in
                categories.first(where: {$0.key == name})
            })
            if symbolCategories.isEmpty {
                symbolCategories.append(Category.uncategorized)
            }
            let searchTerms = symbolSearchTermsDict[name] ?? []
            let osAvailabilityDict = symbolAvailability.year_to_release[releaseYear] ?? [:]
            let osVersions = osAvailabilityDict.map { os, version in
                OSVersion(os: os, version: version)
            }
            symbols.append(
                Symbol(
                    name: name,
                    releaseYear: releaseYear,
                    categories: symbolCategories,
                    searchTerms: searchTerms,
                    osVersions: osVersions
                )
            )
        }
        symbols.sort(using: KeyPathComparator(\.name))
    }
    
    func decodePlist<T:Decodable>(_ type: T.Type, from fileName: String) -> T {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist") else {
            fatalError("Failed to locate \(fileName)")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(fileName) from bundle")
        }
        let decoder = PropertyListDecoder()
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(fileName) from bundle")
        }
        return decodedData
    }
    
    func availableCategories(limitedCategories: [CategoryEnum]) -> [Category] {
        let allowedKeys = Set(limitedCategories.map { $0.rawValue })
        return limitedCategories.isEmpty ? categories : categories.filter({allowedKeys.contains($0.key)})
    }

}
