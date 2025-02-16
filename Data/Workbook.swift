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
    @Attribute(.externalStorage) var data: Data?
    @Attribute(.externalStorage) var imgData: Data?
    var lastAccessed: Date

    init(name: String, data: Data? = nil, imgData: Data? = nil, lastAccessed: Date) {
        self.name = name
        self.id = UUID()
        self.data = data
        self.imgData = imgData
        self.lastAccessed = lastAccessed
    }
}
