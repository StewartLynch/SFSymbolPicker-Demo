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

struct Category: Decodable {
    let icon: String
    let key: String
    let label: String
    static var uncategorized: Category {
        Category(icon: "questionmark.circle", key: "uncategorized", label: "Uncategorized")
    }
}

struct Symbol_Categories {
    let name: String
    let categories: [String]
}

struct Symbol_SearchTerms {
    let name: String
    let searchTerms: [String]
}

struct Symbol_Availability: Decodable {
    let symbols: [String : String]
    let year_to_release: [String : [String : String]]
}

struct OSVersion {
    let os: String
    let version: String
}

struct Symbol {
    let name: String
    let releaseYear: String
    let categories: [Category]
    let searchTerms: [String]
    let osVersions: [OSVersion]
}


enum CategoryEnum: String {
    case uncategorized, accessibility, arrows, automotive, cameraandphotos, commerce, communication, connectivity, devices, editing, fitness, gaming, health, home, human, indices, keyboard, maps, math, media, multicolor, nature, objectsandtools, privacyandsecurity, shapes, textformatting, time, transportation, variablecolor, weather, whatsnew
}
