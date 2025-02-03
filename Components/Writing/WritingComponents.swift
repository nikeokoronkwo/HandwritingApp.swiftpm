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
    var writingModel: WritingModel { get }
    var canvasView: PKCanvasView { get }
}



struct WritingView: WritingCanvas {
    @Environment(\.undoManager) private var undoManager
    // iOS 17.5
//    @Environment(\.preferredPencilDoubleTapAction) private var preferredAction
    @StateObject var writingModel: WritingModel = WritingModel()
    @State internal var canvasView = PKCanvasView()
    
    func updateCanvasEraserTool() {
        
    }

    var body: some View {
        NavigationStack {
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

}

#Preview {
    WritingView()
}
