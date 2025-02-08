//
//  Assets.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 07/02/2025.
//

/// # Levels Type
/// This type is used for declaring a level in swift
struct Levels: Codable {
    enum LevelType: RawRepresentable, Codable {
        init?(rawValue: String) {
            switch rawValue {
                case "word":
                    self = .word
                case "img":
                    self = .img
            default:
                return nil
            }
        }
        
        var rawValue: String {
            switch self {
            case .word:
                return "word"
            case .img:
                return "img"
            }
        }
        
        typealias RawValue = String
        
        case word
        case img
    }
    
    struct LevelInfo: Codable {
        var type: LevelType
        var value: String
    }
    
    var index: Int
    var name: String
    var isCompleted: Bool?
    var score: Float?
    var info: LevelInfo
}

/// A data type to represent the JSON file used for initialising the levels for the application when initially installed
struct LevelsAsset: Codable {
    var basic: [Levels]
    var advanced: [Levels]
    var expert: [Levels]
}
