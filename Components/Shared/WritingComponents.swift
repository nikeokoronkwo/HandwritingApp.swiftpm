//
//  SwiftUIView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import PencilKit
// TODO: This file needs to be sorted out --- a huge lot
import SwiftUI

enum WritingSelection: String, CaseIterable {
    case pen = "Pen"
    case eraser = "Eraser"

    init?(id: Int) {
        switch id {
        case 1: self = .pen
        case 2: self = .eraser
        default: return nil
        }
    }
}

extension WritingSelection: Identifiable {
    var id: RawValue { rawValue }
}

struct HandWritingCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView

    func makeUIView(context: Context) -> some UIView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.isOpaque = false
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 20)
        return canvasView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}

struct WritingView: View {
    @Binding var canvasView: PKCanvasView

    var body: some View {
        VStack {
            HandWritingCanvas(canvasView: $canvasView)
        }
    }
}

struct ContentView: View {
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @State private var writingSelection: WritingSelection = .pen

    @State private var clearDrawing: Bool = false

    //    func editCanvasTool(selection: WritingSelection) {
    //        switch selection {
    //        case .pen:
    //            canvasView.tool = PKInkingTool(.pen, color: .black, width: 20)
    //        case .eraser:
    //            canvasView.tool = PKEraserTool(.vector, width: 20)
    //        }
    //    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ZStack {
                        NoteBookView(spacing: 80, lines: 20)
                        WritingView(canvasView: $canvasView)
                    }
                }
                HStack(spacing: 20) {
                    Picker("Writing Tool", selection: $writingSelection) {
                        ForEach(WritingSelection.allCases) { selection in
                            Text(selection.rawValue).tag(selection)
                        }
                    }
                    //                    .onChange(of: writingSelection, { oldValue, newValue in
                    //                        if oldValue != newValue { editCanvasTool(selection: newValue) }
                    //                    })
                    .pickerStyle(.segmented)

                    Button("Clear") {
                        clearDrawing.toggle()
                    }
                    .confirmationDialog(
                        "Clear Writing", isPresented: $clearDrawing,
                        actions: {
                            Button("Cancel", role: .cancel) {}
                            Button("Clear") {
                                canvasView.drawing = PKDrawing()
                            }
                        },
                        message: {
                            Text("Are you sure you want to clear the writing")
                        }
                    )
                    .foregroundStyle(Color(.red))
                    .buttonStyle(DefaultButtonStyle())
                }
                .padding(20)
                .background(Color(UIColor.systemBackground))
            }
        }
    }

}

#Preview {
    ContentView()
}
