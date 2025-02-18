//
//  LevelsModel.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//
import SwiftUI

class
    //struct
    LevelsModel: ObservableObject
{
    @Published
    var jsonPath: URL?
    @Published
    var assetPath: [String: URL]

    init(jsonPath: URL? = nil, assetPath: [String: URL] = [:]) {
        self.jsonPath = jsonPath
        self.assetPath = assetPath

        if let p = jsonPath {
            self._levelAssets = try? loadAssets(url: p)
        } else {
            self._levelAssets = nil
        }
    }

    private var assetsChanged: Bool = false
    private var _levelAssets: LevelsAsset?
    var levelAssets: LevelsAsset? {
        get {
            if _levelAssets == nil {
                if let p = jsonPath {
                    self._levelAssets = try? loadAssets(url: p)
                }
            }
            return _levelAssets
        }
        set {
            _levelAssets = newValue

            let data = try? JSONEncoder().encode(levelAssets)

            if let url = jsonPath {
                try? data?.write(to: url, options: [.atomic])
            }
        }
    }
}

//struct LevelModelKey: EnvironmentKey {
//    static let defaultValue: LevelsModel? = nil
//}
//
//extension EnvironmentValues {
//    var levelModel: LevelsModel? {
//        get { self[LevelModelKey.self] }
//        set { self[LevelModelKey.self] = newValue }
//    }
//}
