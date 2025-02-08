//
//  Realtime.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 07/02/2025.
//

import SwiftData
import Foundation

/// # Realtime Data
/// Realtime data is used to track your progress when it comes to writing in the application. This keeps track of the kind of problems you do, how long it takes as well as how good you do on each problem.
///
/// This data is then used in Charts to plot how good you're doing via different measures, such as performace over time, the problems you tend to have problems with, how good you are for a given difficulty, and much more.
///
/// ## Data Structure
///
/// ## Additions
/// - Should we add the drawing data as at then?
@Model
class RealtimeWritingModel {
    /// Whether this is referencing a core level
    var core: Bool
    
    /// The ID of this realtime stamp
    @Attribute(.unique) var id: UUID = UUID()
    
    /// The timestamp of this stamp
    var time: Date
    
    /// The user's score for the given reference
    var score: Float
    
    /// The difficulty of the given level (can be inferred if it is core)
    var difficulty: Float
    
    /// The writing being referenced
    var writing: WritingModel
    
    init(core: Bool, time: Date, score: Float, difficulty: Float, writing: WritingModel) {
        self.core = core
        self.time = time
        self.score = score
        self.difficulty = difficulty
        self.writing = writing
    }
}

extension RealtimeWritingModel {
    /// The ID of the referenced level, as a UUID
    var refId: UUID {
        return writing.id
    }
}
