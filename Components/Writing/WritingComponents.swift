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
protocol WritingCanvas: View {
    var writingModel: WritingManager { get }
    var canvasView: PKCanvasView { get }
}

struct WritingViewContainer {
    /// the drawing
    
}

struct WritingView: WritingCanvas {
    @Environment(\.undoManager) private var undoManager
    @StateObject var writingModel: WritingManager = WritingManager()
    @State var canvasView = PKCanvasView()
    
//    @Binding var writingViewContainer: WritingViewContainer
    
//    init(_ model: Binding<WritingViewContainer>) {
//        self._writingViewContainer = model
//    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack {
                    NoteBookBackground(spacing: 80, lines: 20)
                    HandWritingCanvas(canvasView: $canvasView)
                }
            }
            // iOS 17.5
            // The toolbar
            ToolBarComponent(canvasView: $canvasView)
        }
        .environmentObject(writingModel)
    }

}

@available(iOS 17.5, *)
struct WritingView_17_5: WritingCanvas {
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
                    HandWritingCanvas(canvasView: $canvasView)
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
