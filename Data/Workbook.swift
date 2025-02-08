//
//  Workbook.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 03/02/2025.
//

import Foundation
import SwiftData

/// # Workbooks
/// This is a workbook class, used to store data (metadata) about
@Model
class Workbook {
    var name: String
    @Attribute(.unique) var id: UUID = UUID()
    @Attribute(.externalStorage) var data: Data
    var lastAccessed: Date

    init(name: String, data: Data, lastAccessed: Date) {
        self.name = name
        self.data = data
        self.lastAccessed = lastAccessed
    }
}
