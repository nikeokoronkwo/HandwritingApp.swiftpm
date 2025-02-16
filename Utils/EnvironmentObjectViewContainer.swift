//
//  EnvironmentObjectViewContainer.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 10/02/2025.
//

import SwiftUI

struct EnvironmentObjectViewContainer<V: View>: View {
    private var model: LevelsModel
    var content: V

    init(@ViewBuilder _ content: () -> V) {
        self.content = content()

        guard let levelsBundleUrl = Bundle.main.url(forResource: "levels", withExtension: "json")
        else {
            // error out
            self.model = LevelsModel()
            return
            //            throw AssetError.notFound
        }

        guard
            let assetsBundleUrls = Bundle.main.urls(
                forResourcesWithExtension: "png", subdirectory: ".")
        else {
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

            guard
                let levelDataAsJson = try? JSONDecoder().decode(
                    LevelsAsset.self, from: levelData.data(using: .utf8)!)
            else {
                // throw error
                throw AssetError.invalid("Invalid JSON at \(levelsBundleUrl) -> \(levelData)")
            }

            if levelDataAsJson.advanced.count == 0 || levelDataAsJson.basic.count == 0
                || levelDataAsJson.expert.count == 0
            {
                // throw error

            }

            let assetsDataDict = try assetsBundleUrls.reduce(into: [String: Data]()) {
                partialResult, url in
                partialResult[url.lastPathComponent] = try Data(contentsOf: url)
            }

            try levelData.write(
                to: documentsUrl.appending(path: "levels.json"), atomically: true, encoding: .utf8)

            var isDir: ObjCBool = true

            try assetsDataDict.forEach { aDictElement in
                if !FileManager.default.fileExists(
                    atPath: documentsUrl.appending(path: "assets").absoluteString,
                    isDirectory: &isDir)
                {
                    try FileManager.default.createDirectory(
                        at: documentsUrl.appending(path: "assets"),
                        withIntermediateDirectories: true)
                }
                try aDictElement.value.write(
                    to: documentsUrl.appending(path: "assets").appending(path: aDictElement.key),
                    options: [.atomic, .completeFileProtection])
            }

            var newAssetModel: [String: URL] = [:]
            assetsDataDict.forEach { el in
                newAssetModel[el.key] = documentsUrl.appending(path: "assets").appending(
                    path: el.key)
            }

            let model = LevelsModel(
                jsonPath: documentsUrl.appending(path: "levels.json"),
                assetPath: newAssetModel
            )

            self.model = model

        } catch {
            // handle errors
            debugPrint(error)
            debugPrint("****ENVObjectViewContainer********")
            self.model = LevelsModel()
        }
    }

    var body: some View {
        Group {
            content
        }
        .environment(\.levelModel, model)
    }
}
