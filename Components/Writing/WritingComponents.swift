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

struct WritingView: WritingCanvas {
    @Environment(\.undoManager) private var undoManager
    @StateObject var writingModel: WritingManager = WritingManager()
    @State var canvasView = PKCanvasView()

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack {
                    NoteBookView(spacing: 80, lines: 20)
                    HandWritingCanvas(canvasView: $canvasView)
                }
            }
            // iOS 17.5
            //                .onPencilDoubleTap { value in
            //
            //                }
            // The toolbar
            ToolBarComponent(canvasView: $canvasView)
        }
        .environmentObject(writingModel)
    }

}

@available(iOS 17.5, *)
struct WritingView_17_5: View {
    @Environment(\.undoManager) private var undoManager
    // iOS 17.5
    @Environment(\.preferredPencilDoubleTapAction) private var preferredAction
    @StateObject var writingModel: WritingManager = WritingManager()
    @State var canvasView: PKCanvasView = .init()

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack {
                    NoteBookView(spacing: 80, lines: 20)
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
    WritingView()
}
