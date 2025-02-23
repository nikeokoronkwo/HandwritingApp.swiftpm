import PencilKit
//
//  WritingController.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 17/02/2025.
//
import SwiftUI

/// # Writing Controller
/// The writing controller acts as a delegate controller that is used for passing and getting data from the handwriting view
///
/// From this controller, we can get the ``drawing`` from the ``PKCanvas``
class WritingController: ObservableObject {
    /// The curent drawing from the writing canvas
    @Published var drawing: PKDrawing?

    /// The ``drawing`` rendered as an image and stored as ``Data``
    @Published var imgData: Data?

    var onDrawing: (PKDrawing) -> Void

    init(drawing: PKDrawing? = nil, img: Data? = nil, onDrawing: @escaping (PKDrawing) -> Void) {
        self.drawing = drawing
        self.imgData = img
        self.onDrawing = onDrawing
    }

    init(_ drawing: PKDrawing? = nil, onDrawing: @escaping (PKDrawing) -> Void) {
        self.drawing = drawing
        if let d = drawing {
            self.imgData = d.image(from: d.bounds, scale: 1).pngData()
        }
        self.onDrawing = onDrawing
    }

}
