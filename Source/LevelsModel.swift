//
//  LevelsModel.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//
import Foundation


class
//struct
LevelsModel
: ObservableObject
{
    @Published
    var jsonPath: URL?
    @Published
    var assetPath: [String: URL]
    
    init(jsonPath: URL? = nil, assetPath: [String : URL] = [:]) {
        self.jsonPath = jsonPath
        self.assetPath = assetPath
    }
    
    lazy var levelAssets: LevelsAsset? = {
        if let p = jsonPath {
            return try? loadAssets(url: p)
        }
        // should throw error sha
        return nil
    }()
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
