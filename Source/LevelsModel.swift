//
//  LevelsModel.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//
import SwiftUI


//class
struct
LevelsModel
//: ObservableObject
{
//    @Published
    var jsonPath: URL?
//    @Published
    var assetPath: [String: URL]
    
    init(jsonPath: URL? = nil, assetPath: [String : URL] = [:]) {
        self.jsonPath = jsonPath
        self.assetPath = assetPath
        
        if let p = jsonPath {
            self.levelAssets = try? loadAssets(url: p)
        } else {
            self.levelAssets = nil
        }
    }
    
    var levelAssets: LevelsAsset?
}

struct LevelModelKey: EnvironmentKey {
    static let defaultValue: LevelsModel? = nil
}

extension EnvironmentValues {
    var levelModel: LevelsModel? {
        get { self[LevelModelKey.self] }
        set { self[LevelModelKey.self] = newValue }
    }
}
