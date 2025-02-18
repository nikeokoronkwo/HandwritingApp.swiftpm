//
//  WritingController.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 17/02/2025.
//
import SwiftUI
import PencilKit

class WritingController: ObservableObject {
    @Published var drawing: PKDrawing?
    @Published var imgData: Data?

    init(drawing: PKDrawing? = nil, img: Data? = nil) {
        self.drawing = drawing
        self.imgData = img
    }
}
