//
//  WritingManager.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import SwiftUI

/// A model object for working with the tools needed for writing
///
/// This object is an ``ObservableObject`` with variables that are relating to the tools that are to be monitored
class WritingManager: ObservableObject {

    /// ## TOOLS
    /// - Pen vs Eraser
    /// - Pen Options
    ///     - Ink Width
    ///     - (Stretch) Ink Colour (black vs blue)
    /// - Eraser Options
    ///     - Pixel vs Vector Eraser

    //

    @Published var selectedTool: WritingSelection = .pen
    @Published var penOptions: WritingPenOptions = .init()
    @Published var eraserOptions: WritingEraserOptions = .init()

    /// The selected tool
    enum WritingSelection: String, CaseIterable, Identifiable {
        case pen = "Pen"
        case eraser = "Eraser"

        /// Makes the writing selection ``Identifiable`` so that they can be used in a picker/
        var id: RawValue { rawValue }
    }

    enum EraserType: String, CaseIterable, Identifiable {
        case pixel = "Pixel"
        case vector = "Vector"

        var id: RawValue { rawValue }
    }

    /// Options for configuring the pen options
    struct WritingPenOptions {
        var inkWidth: CGFloat
        var inkColour: Color = .black

        init() {
            if #available(iOS 17, *) {
                inkWidth = 2.5
            } else {
                inkWidth = 6
            }
        }
    }

    /// Options for configuring the eraser options
    struct WritingEraserOptions {
        var eraserType: EraserType = .pixel
        var eraserWidth: CGFloat = 10
    }
}
