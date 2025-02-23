//
//  WritingCanvas.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import PencilKit
import SwiftUI

class PKCanvasCoordinator: NSObject, PKCanvasViewDelegate {
    @ObservedObject var writingController: WritingController

    init(_ writingController: WritingController) {
        self.writingController = writingController
    }

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        writingController.drawing = canvasView.drawing
        writingController.imgData = canvasView.drawing.image(
            from: canvasView.drawing.bounds, scale: 1.0
        )
        .pngData()
        writingController.onDrawing(canvasView.drawing)
    }
}

/// The base interface for interfacing PencilKit's ``PKCanvasView`` with SwiftUI
///
/// At the moment it is a minimal wrapper with support only for necessary tools needed for this handwriting application
struct WritingCanvas: UIViewRepresentable {
    @EnvironmentObject var writingModel: WritingManager
    @EnvironmentObject var writingController: WritingController
    @Binding var canvasView: PKCanvasView

    private func updateCanvasTool() {
        // iOS 17 = .monoline
        switch writingModel.selectedTool {
        case .eraser:
            let eraserType: PKEraserTool.EraserType =
                writingModel.eraserOptions.eraserType == .pixel ? .bitmap : .vector
            canvasView.tool = PKEraserTool(
                eraserType, width: writingModel.eraserOptions.eraserWidth)
        case .pen:
            canvasView.tool = PKInkingTool(
                .monoline, color: UIColor(writingModel.penOptions.inkColour),
                width: writingModel.penOptions.inkWidth)
        }
    }

    func makeUIView(context: Context) -> some UIView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.isOpaque = false
        canvasView.delegate = context.coordinator

        updateCanvasTool()
        return canvasView
    }

    func makeCoordinator() -> PKCanvasCoordinator {
        PKCanvasCoordinator(writingController)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateCanvasTool()
    }
}
