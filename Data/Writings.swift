//
//  Writings.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 07/02/2025.
//

import Foundation
import SwiftData

@Model
class WritingModel {
    /// The ID of the given writing
    @Attribute(.unique) var id: UUID = UUID()

    /// The current date
    var updated: Date

    /// The current score of the user
    var score: Float

    /// Whether this references a core level
    var core: Bool

    /// The data used for the given level, as text
    var data: String

    /// The title for a given level, if set
    var title: String?

    /// The user's drawing stored externally but referenced here
    @Attribute(.externalStorage) var result: Data?

    init(updated: Date, score: Float, core: Bool, data: String, result: Data? = nil) {
        self.updated = updated
        self.score = score
        self.core = core
        self.data = data
        self.result = result
    }
}

extension WritingModel {
    var isCompleted: Bool {
        return score >= 100.0
    }
}
