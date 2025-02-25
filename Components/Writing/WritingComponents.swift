//
//  SwiftUIView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import PencilKit
import SwiftUI

/// # Writing Canvas Protocol
/// This protocol is intended for sharing functionality between the workbook writer and the normal handwriting view
///
/// Any tool that will make use of writing in this app conforms to this protocol, as it provides the environment for the canvas and the
protocol WritingCanvasRepresentable: View {
    var writingModel: WritingManager { get }
    var canvasView: PKCanvasView { get }
}

struct WritingView: WritingCanvasRepresentable {
    @Environment(\.undoManager) private var undoManager
    @StateObject var writingModel: WritingManager = WritingManager()
    @ObservedObject var writingController: WritingController
    @State var canvasView = PKCanvasView()

    init(_ controller: WritingController) {
        self.writingController = controller

        let canvasView = PKCanvasView()

        if let drawing = controller.drawing {
            canvasView.drawing = drawing
        }

        self._canvasView = State(initialValue: canvasView)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack {
                    NoteBookBackground(spacing: 80, lines: 20)
                    WritingCanvas(
                        canvasView: Binding<PKCanvasView>(
                            get: {
                                return canvasView
                            },
                            set: { newValue in
                                debugPrint(newValue)
                                // set canvas drawing in manager
                                writingController.drawing = newValue.drawing

                                // update canvas
                                canvasView = newValue
                            }))
                }
            }
            // iOS 17.5
            // The toolbar
            ToolBarComponent(canvasView: $canvasView)
        }
        .environmentObject(writingModel)
        .environmentObject(writingController)
    }

}

@available(iOS 17.5, *)
struct WritingView_17_5: WritingCanvasRepresentable {
    @Environment(\.undoManager) private var undoManager
    // iOS 17.5
    @Environment(\.preferredPencilDoubleTapAction) private var preferredAction
    @StateObject var writingModel: WritingManager = WritingManager()
    @State var canvasView: PKCanvasView = .init()

    /// A closure that runs upon saving a PKDrawing
    /// This closure is called once returning or

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack {
                    NoteBookBackground(spacing: 80, lines: 20)
                    WritingCanvas(canvasView: $canvasView)
                }
            }
            // iOS 17.5
            .onPencilDoubleTap { value in

            }
            .onPencilSqueeze { phase in

            }
            // The toolbar
            ToolBarComponent(canvasView: $canvasView)
        }
        .environmentObject(writingModel)
    }
}

#Preview {
    //    let writingViewContainer = WritingViewContainer()
    //    WritingView()
}

#Preview("iOS 17.5") {
    if #available(iOS 17.5, *) {
        WritingView_17_5()
    } else {
        Text("Unavailable")
    }
}
