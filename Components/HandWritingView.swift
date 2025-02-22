//
//  HandWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import PencilKit
import SwiftUI

struct HandWritingView: View {
    /// The writing model for the given view, if any
    /// Used for populating existing data
    @Bindable var model: WritingModel
    
    /// The controller used for controlling, getting data from the ``WritingCanvas``
    @StateObject var writingController: WritingController = WritingController { drawing in
        
    }

    init(model: WritingModel) {
        self.model = model
        self.model.updated = Date()

        if let data = model.result {
            let drawing = try? PKDrawing(data: data)
            self._writingController = StateObject(wrappedValue: WritingController(drawing: drawing)  { drawing in
            })
        } else {
            self._writingController = StateObject(wrappedValue: WritingController  { drawing in
            })
        }
    }

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label {
                    Text("Return")
                } icon: {
                    Image(systemName: "arrow.left")
                }
                .padding()
            }
        }
    }
}

struct CoreWritingView: WritingCanvasRepresentable {
    @Environment(\.undoManager) private var undoManager
    /// The writing manager, used for the toolbar and toolset for configuring the ``WritingCanvas``
    @StateObject var writingModel: WritingManager = WritingManager()
    /// The controller used for controlling, getting data from the ``WritingCanvas``
    @ObservedObject var writingController: WritingController
    
    /// The canvas that the ``WritingCanvas`` and ``ToolBarComponent`` are bound to
    @State var canvasView = PKCanvasView()
    
    /// The writing model for the given view
    /// Used for populating existing data, and to save the data associated with the given view
    @Bindable var model: WritingModel
    
    /// The model context used for saving realtime data context on a given user
    

    init(_ writingModel: WritingModel) {
        let canvasView = PKCanvasView()

        self._canvasView = State(initialValue: canvasView)
        self.model = writingModel

        if let data = writingModel.result {
            let dwg = try! PKDrawing(data: data)
            canvasView.drawing = dwg
            self.writingController = WritingController(dwg) { drawing in
                // handle drawing
            }
        } else {
            self.writingController = WritingController { drawing in
                // handle drawing
            }
        }

    }

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZStack {
                    NoteBookWithTextBackground(spacing: 150, lines: 4) {
                        Image(
                            model.data.dotted_image(
                                model.data.count < 1 ? 200 : geometry.size.width * 0.123)!,
                            scale: 1, label: Text(model.data))
                    }

                    WritingCanvas(
                        canvasView: Binding<PKCanvasView>(
                            get: {
                                return canvasView
                            },
                            set: { newValue in
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

#Preview("Practice HW View") {
    let model = WritingModel(updated: Date(), score: 30, core: false, data: "my hands")
    HandWritingView(model: model)
}

#Preview {
    let model = WritingModel(updated: Date(), score: 0, core: false, data: "moin moin")
    CoreWritingView(model)
}

#Preview {
    let model = WritingModel(updated: Date(), score: 70, core: false, data: "drinking\nwater")
    CoreWritingView(model)
}

#Preview {
    let model = WritingModel(updated: Date(), score: 30, core: false, data: "mary had a lamb,\na fast lamb like...")
    CoreWritingView(model)
}
