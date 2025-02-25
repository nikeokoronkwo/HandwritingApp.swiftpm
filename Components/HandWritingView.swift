//
//  HandWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import PencilKit
import SwiftData
import SwiftUI

struct HandWritingView: View {
    @Environment(\.undoManager) private var undoManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Environment(\.colorScheme) private var colorScheme
    
    /// The writing model for the given view, if any
    /// Used for populating existing data
    @Bindable var model: WritingModel
    
    /// The writing manager, used for the toolbar and toolset for configuring the ``WritingCanvas``
    @StateObject var writingModel: WritingManager = WritingManager()


    /// The controller used for controlling, getting data from the ``WritingCanvas``
    @StateObject var writingController: WritingController = WritingController { drawing in

    }
    
    /// The canvas that the ``WritingCanvas`` and ``ToolBarComponent`` are bound to
    @State var canvasView = PKCanvasView()
    
    var imageForPractice: CGImage {
        model.data.dotted_image(150)
    }

    init(model: WritingModel) {
        self.model = model
        self.model.updated = Date()

        if let data = model.result {
            let drawing = try? PKDrawing(data: data)
            self._writingController = StateObject(
                wrappedValue: WritingController(drawing: drawing) { drawing in
                    
                    model.result = drawing.dataRepresentation()
                })
        } else {
            self._writingController = StateObject(
                wrappedValue: WritingController { drawing in
                    
                    model.result = drawing.dataRepresentation()
                })
        }
    }

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZStack {
                    NoteBookWithTextBackground(spacing: 150, lines: 4) {
                        if colorScheme == .dark {
                            Image(
                                imageForPractice,
                                scale: 1, label: Text(model.data)
                            )
                            .colorInvert()
                        } else {
                            Image(
                                imageForPractice,
                                scale: 1, label: Text(model.data)
                            )
                        }
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
            VStack {
                ToolBarComponent(canvasView: $canvasView)
//                Text("\(index ?? -1)")
            }
        }
        .environmentObject(writingModel)
        .environmentObject(writingController)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    model.result = canvasView.drawing.dataRepresentation()
                    
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }

            }
        }
    }
}

private func learnPredicate() -> Predicate<WritingModel> {
    return #Predicate<WritingModel> { model in
        model.core
    }
}

struct CoreWritingView: WritingCanvasRepresentable {
    /// The writing models for the given view
    /// Used for populating existing data, and to save the data associated with the given view
    @Query(filter: learnPredicate(), sort: \.updated) private var levelInfo: [WritingModel]

    @Environment(\.undoManager) private var undoManager
    @Environment(\.modelContext) private var modelContext

    @Environment(\.colorScheme) private var colorScheme

    @EnvironmentObject private var levelModel: LevelsModel
    /// The writing manager, used for the toolbar and toolset for configuring the ``WritingCanvas``
    @StateObject var writingModel: WritingManager = WritingManager()
    /// The controller used for controlling, getting data from the ``WritingCanvas``
    @ObservedObject var writingController: WritingController

    /// The canvas that the ``WritingCanvas`` and ``ToolBarComponent`` are bound to
    @State var canvasView = PKCanvasView()

    /// Whether the user has interacted with the view, to know if he can nav or not
    @State var hasInteracted: Bool = false

    @State var levelIndex: Int
    
    /// The current model in focus here
    @State var currentModel: WritingModel?
    @State private var newModel: Bool = false

    var levelType: LevelType
    
    fileprivate func getCGImg() -> CGImage? {
        let drawing = canvasView.drawing
        
        let img = drawing.image(from: CGRect(x: 0, y: 0, width: targetImageForLevel.width, height: targetImageForLevel.height), scale: 1)
        
        guard let cgImg = convertUIImageToCGImage(input: img) else { return nil }
        
        return cgImg
    }
    
    @State private(set) var index: Float? = nil

    var level: Level {
        levelModel.levelAssets.forType(levelType).first(where: { l in
            l.index == levelIndex
        })!
    }

    var imageForLevel: CGImage {
        level.info.value.dotted_image(150)
    }
    
    var targetImageForLevel: CGImage {
        level.info.value.image(150)
    }

    func logOnExit() {
        if newModel {
            modelContext.insert(currentModel!)
            debugPrint("insert")
            try! modelContext.save()
            newModel = false
        }
    }

    // runs whenever navigating to the next drawing
    func updateCanvas() {
        prepareCanvas(update: true)
    }
    
    private func prepareCanvas(update: Bool = false) {
        
        if levelInfo.isEmpty
            || levelInfo.filter({ mdl in
                mdl.title == level.name
            }).isEmpty
        {
            newModel = true
            currentModel = WritingModel(level, updated: Date.now, score: 0)
            if update {
                canvasView.drawing = PKDrawing()
            }
        } else {
            if let mdl = levelInfo.filter({ mdl in
                mdl.result != nil && mdl.title == level.name
            }).first {
                currentModel = mdl
                let dwg = try! PKDrawing(data: mdl.result!)
                canvasView.drawing = dwg
                writingController.drawing = dwg
            } else {
                currentModel = levelInfo.filter({ mdl in
                    mdl.title == level.name
                }).first
                if update {
                    canvasView.drawing = PKDrawing()
                }
            }
        }
    }

    func setupCanvas() {
        prepareCanvas()
        
        writingController.onDrawing = { drawing in
            
            currentModel?.result = drawing.dataRepresentation()
            currentModel?.updated = Date.now
            
            if !hasInteracted { hasInteracted = true }

            guard let cgImg = getCGImg() else { return }
            
            do {
                index = try ssim(targetImageForLevel, cgImg)
            } catch {
                debugPrint(error)
                return
            }
        }
    }

    //    @Bindable var model: WritingModel

    /// The model context used for saving realtime data context on a given user
    ///

    init(_ levelIndex: Int, forType type: LevelType, title: String) {
        self.levelType = type
        // select level from id
        self._levelIndex = State<Int>(initialValue: levelIndex)

        let canvasView = PKCanvasView()

        self._canvasView = State<PKCanvasView>(initialValue: canvasView)

        self.writingController = WritingController { dwg in
            // run task
        }

    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZStack {
                    if levelType == .expert {
                        NoteBookBackground(spacing: 150, lines: 4)
                    } else {
                        NoteBookWithTextBackground(spacing: 150, lines: 4) {
                            if colorScheme == .dark {
                                Image(
                                    imageForLevel,
                                    scale: 1, label: Text(level.name)
                                )
                                .colorInvert()
                            } else {
                                Image(
                                    imageForLevel,
                                    scale: 1, label: Text(level.name)
                                )
                            }
                        }
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
            VStack {
                ToolBarComponent(canvasView: $canvasView)
//                Text("\(index ?? -1)")
                if levelType == .expert {
                    Text("**Text**: \(level.info.value)")
                }
            }
            if hasInteracted {
                VStack {
                    Spacer()
                    HStack {
                        if levelIndex > 1 {
                            Button {
                                levelIndex -= 1
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 70, height: 60)
                                    .opacity(0)
                                    .overlay {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 40))
                                    }
                            }
                        }
                        Spacer()
                        if levelModel.levelAssets.forType(levelType).firstIndex(of: level)! < levelModel.levelAssets.forType(levelType).count - 1 {
                            Button {
                                levelIndex += 1

                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 70, height: 60)
                                    .opacity(0)
                                    .overlay {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 40))
                                    }
                            }
                        }
                        
                    }
//                    .frame(height: .infinity)
                        .padding(.horizontal, 20)
                        .background(content: {
                            Rectangle()
                                .opacity(0)
                    })
                    Spacer()
                }
            }
        }
        .onAppear {
            if (currentModel == nil) {
                setupCanvas()
            }
        }
        .onChange(
            of: levelIndex,
            { oldValue, newValue in
                print("\n\n")
                logOnExit()
                debugPrint("logonexit")
                updateCanvas()
            }
        )
        .environmentObject(writingModel)
        .environmentObject(writingController)
    }
}

#Preview("Practice HW View") {
    EnvironmentObjectViewContainer { model in
        CoreWritingView(1, forType: .basic, title: model.levelAssets.forType(.basic).first(where: { l in
            l.index == 1
        })!.name)
    }
    .preferredColorScheme(.light)
}

//#Preview {
//    let level = Level(
//        index: 0, name: "moin moin", info: Level.LevelInfo(type: .word, value: "moin moin"))
//    let model = WritingModel(level, updated: Date.now, score: 0)
//    CoreWritingView(model, level: level)
//}
//
//#Preview {
//    let level = Level(
//        index: 0, name: "Drinking Water",
//        info: Level.LevelInfo(type: .word, value: "drinking\nwater"))
//    let model = WritingModel(level, updated: Date.now, score: 0)
//    CoreWritingView(model, level: level)
//}
//
//#Preview {
//    let level = Level(
//        index: 0, name: "Mary",
//        info: Level.LevelInfo(type: .word, value: "mary had a lamb,\na fast lamb like..."))
//    let model = WritingModel(level, updated: Date.now, score: 0)
//    CoreWritingView(model, level: level)
//        .preferredColorScheme(.dark)
//}
