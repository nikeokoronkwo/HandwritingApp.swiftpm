//
//  LearnView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

// TODO: Add support for "continue from where you stopped" type shi
struct LearnOption {
    var name: String
    var description: String
    var levelType: LevelType
}

enum LevelType {
    case basic
    case advanced
    case expert
}

struct LearnView: View {
    @EnvironmentObject var levelModel: LevelsModel
    
    private var options: [LearnOption] = [
        LearnOption(
            name: "Foundations", description: "Learn the fundamentals of good handwriting",
            levelType: .basic),
        LearnOption(
            name: "Advanced", description: "Get serious and write practically", levelType: .advanced
        ),
        LearnOption(
            name: "Custom", description: "Try out something new, with no guides", levelType: .expert
        ),
    ]
    
    init() {
        debugPrint(self.levelModel)
    }

    var body: some View {
        TriangularLayout {
            ForEach(options, id: \.name) { opt in
                NavigationLink {
                    // TODO: Levels needs to be passed data somehow
                    LevelsView(type: opt.levelType)
                } label: {
                    VStack {
                        // TODO: Overlay incase man wanna continue from where he stopped
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 250, height: 200)
                            .shadow(radius: 4)
                        Text(opt.name)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                        Text(opt.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

            }
        }
    }
}

#Preview {
    let demoLevelModel = LevelsModel(assetPath: [:])
    LearnView()
        .environmentObject(demoLevelModel)
}

struct EnvironmentObjectViewContainer<V: View>: View {
    var model: LevelsModel
    var content: V
    
    init(@ViewBuilder _ content: () -> V) {
        self.content = content()
        
        guard let levelsBundleUrl = Bundle.main.url(forResource: "levels", withExtension: "json") else {
            // error out
            self.model = LevelsModel()
            return
//            throw AssetError.notFound
        }
        
        guard let assetsBundleUrls = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: ".") else {
            // error out
            self.model = LevelsModel()
            return
//            throw AssetError.notFound
        }
        
        // load to documents directory
        let documentsUrl = URL.documentsDirectory
        
        do {
            guard let levelData = try? String(contentsOf: levelsBundleUrl) else {
                // throw error
                throw AssetError.bad("Could not convert asset data to string")
            }
            
            guard let levelDataAsJson = try? JSONDecoder().decode(LevelsAsset.self, from: levelData.data(using: .utf8)!) else {
                // throw error
                throw AssetError.invalid("Invalid JSON at \(levelsBundleUrl)")
            }
            
            if levelDataAsJson.advanced.count == 0 ||
                levelDataAsJson.basic.count == 0 ||
                levelDataAsJson.expert.count == 0 {
                // throw error
                
            }
            
            
            let assetsDataDict = try assetsBundleUrls.reduce(into: [String: Data]()) { partialResult, url in
                partialResult[url.lastPathComponent] = try Data(contentsOf: url)
            }
            
            try levelData.write(to: documentsUrl.appending(path: "levels.json"), atomically: true, encoding: .utf8)
            
            try assetsDataDict.forEach { aDictElement in
                try aDictElement.value.write(to: documentsUrl.appending(path: "assets").appending(path: aDictElement.key), options: [.atomic, .completeFileProtection])
            }
            
            var newAssetModel: [String: URL] = [:]
            assetsDataDict.forEach { el in
                newAssetModel[el.key] = documentsUrl.appending(path: "assets").appending(path: el.key)
            }
            
            let model = LevelsModel(
                jsonPath: documentsUrl.appending(path: "levels.json"),
                assetPath: newAssetModel
            )
            
            self.model = model
            
        } catch {
            // handle errors
            debugPrint(error)
            debugPrint("*****************")
        }
        
        self.model = LevelsModel()
    }
    
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

#Preview("Try with real data") {
    
    
    
}
