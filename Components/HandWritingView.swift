//
//  HandWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI
import PencilKit

struct HandWritingView: View {
    /// The writing model for the given view, if any
    /// Used for populating existing data
    @Bindable var model: WritingModel
    @StateObject var writingController: WritingController = WritingController()

    init(model: WritingModel) {
        self.model = model
        self.model.updated = Date()
        
        if let data = model.result {
            let drawing = try? PKDrawing(data: data)
            self._writingController = StateObject(wrappedValue: WritingController(drawing: drawing))
        } else {
            self._writingController = StateObject(wrappedValue: WritingController())
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
    @StateObject var writingModel: WritingManager = WritingManager()
    @ObservedObject var writingController: WritingController
    @State var canvasView = PKCanvasView()
    @Bindable var model: WritingModel

    init(_ controller: WritingController, model writingModel: WritingModel) {
        self.writingController = controller

        let canvasView = PKCanvasView()
        
        self._canvasView = State(initialValue: canvasView)
        self.model = writingModel

        if let drawing = controller.drawing {
            canvasView.drawing = drawing
            if controller.imgData == nil {
                self.writingController.imgData = controller.drawing?.image(
                    from: canvasView.bounds, scale: 1.0
                ).pngData()
            }
        }
        
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZStack {
                    NoteBookWithTextBackground(spacing: 150, lines: 4) {
                        Image(model.data.image(model.data.count < 1 ? 200 : geometry.size.width * 0.123)!, scale: 1, label: Text(model.data))
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
    let controller = WritingController()
    let model = WritingModel(updated: Date(), score: 30, core: false, data: "moin moin")
    CoreWritingView(controller, model: model)
}

#Preview {
    let controller = WritingController()
    let model = WritingModel(updated: Date(), score: 30, core: false, data: "drinking\nwater")
    CoreWritingView(controller, model: model)
}
