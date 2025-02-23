//
//  Assets.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 07/02/2025.
//
import Foundation

/// # Levels Type
/// This type is used for declaring a level in swift
struct Level: Codable {
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

extension Level.LevelInfo: Equatable, Hashable {}

extension Level: Equatable, Hashable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        return lhs.index == rhs.index && lhs.name == rhs.name && lhs.info == rhs.info
    }
}

/// Simple Levels typealias
typealias Levels = [Level]

/// A data type to represent the JSON file used for initialising the levels for the application when initially installed
struct LevelsAsset: Codable {
    var basic: Levels
    var advanced: Levels
    var expert: Levels
}

extension LevelsAsset {
    func toJson() throws -> String {
        guard
            let json = String(
                data: try JSONEncoder().encode(self),
                encoding: .utf8
            )
        else {
            // custom error
            throw NSError()
        }
        return json
    }
}

// FIXME: Fix asset loading to handle error catching
func loadAssets(url: URL) throws -> LevelsAsset {
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(LevelsAsset.self, from: data)
}
