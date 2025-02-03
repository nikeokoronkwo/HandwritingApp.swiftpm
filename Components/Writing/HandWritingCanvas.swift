//
//  HandWritingCanvas.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import SwiftUI
import PencilKit


/// The base interface for interfacing PencilKit's ``PKCanvasView`` with SwiftUI
///
/// At the moment it is a minimal wrapper with support only for necessary tools needed for this handwriting application
struct HandWritingCanvas: UIViewRepresentable {
    @EnvironmentObject var writingModel: WritingModel
    @Binding var canvasView: PKCanvasView

    private func updateCanvasTool() {
        // iOS 17 = .monoline
        switch writingModel.selectedTool {
        case .eraser:
            let eraserType: PKEraserTool.EraserType = writingModel.eraserOptions.eraserType == .pixel ? .bitmap : .vector
            if #available(iOS 16.4, *) {
                canvasView.tool = PKEraserTool(eraserType, width: writingModel.eraserOptions.eraserWidth)
            } else {
                canvasView.tool = PKEraserTool(eraserType)
            }
        case .pen:
            if #available(iOS 17, *) {
                canvasView.tool = PKInkingTool(.monoline, color: UIColor(writingModel.penOptions.inkColour), width: writingModel.penOptions.inkWidth)
            } else {
                canvasView.tool = PKInkingTool(.pen, color: UIColor(writingModel.penOptions.inkColour), width: writingModel.penOptions.inkWidth)
            }
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.isOpaque = false
        updateCanvasTool()
        return canvasView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateCanvasTool()
    }
}
