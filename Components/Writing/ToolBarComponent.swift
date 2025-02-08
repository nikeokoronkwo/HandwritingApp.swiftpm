//
//  ToolBarComponent.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//


import PencilKit
import SwiftUI

struct HWToggleStyle: ToggleStyle {
    var topImage: String?
    var bottomImage: String?
    var color: Color?
    
    private let toggleWidth: CGFloat = 48.0
    
    init(topImage: String? = nil, bottomImage: String? = nil, color: Color? = nil) {
        self.topImage = topImage
        self.bottomImage = bottomImage
        self.color = color
    }
    
    // TODO: Use Geometry Reader
    func makeBody(configuration: Configuration) -> some View {
        Capsule()
            .fill(Color(.systemGray5))
            .overlay {
                Circle()
                    .fill(.white)
                    .padding(8)
                    .overlay {
                        Image(systemName: (configuration.isOn ? self.topImage: self.bottomImage) ?? "")
                            .foregroundColor(Color.black)
                        
                    }
                    .offset(y: configuration.isOn ? -20 : 20)
            }
        // TODO: Fixed Width
            .frame(width: toggleWidth)
            .scaleEffect(1.2)
            .onTapGesture {
                withAnimation(.spring()) {
                    configuration.isOn.toggle()
                }
            }
    }
}

extension ToggleStyle where Self == HWToggleStyle {
    static var hw: HWToggleStyle { .init() }
}

extension WritingManager {
    var toggleIsOn: Bool {
        get {
            selectedTool == .pen
        }
        set {
            if newValue {
                selectedTool = .pen
            } else {
                selectedTool = .eraser
            }
        }
    }
    
    var toggleEraserType: Bool {
        get {
            eraserOptions.eraserType == .pixel
        }
        set {
            if newValue {
                eraserOptions.eraserType = .pixel
            } else {
                eraserOptions.eraserType = .vector
            }
        }
    }
}

struct ToolBarComponent: View {
    @EnvironmentObject var writingModel: WritingManager
    @Binding var canvasView: PKCanvasView
    
    private let itemSpacing: CGFloat = 40.0
    
    func updateCanvasTool() {
        switch writingModel.selectedTool {
        case .pen:
            // Varies by iOS version available
            if #available(iOS 17, *) {
                canvasView.tool = PKInkingTool(.monoline, color: UIColor(writingModel.penOptions.inkColour), width: writingModel.penOptions.inkWidth)
            } else {
                canvasView.tool = PKInkingTool(.pen, color: UIColor(writingModel.penOptions.inkColour), width: writingModel.penOptions.inkWidth)
            }
        case .eraser:
            let eraserType: PKEraserTool.EraserType = writingModel.eraserOptions.eraserType == .pixel ? .bitmap : .vector
            if #available(iOS 16.4, *) {
                canvasView.tool = PKEraserTool(eraserType, width: writingModel.eraserOptions.eraserWidth)
            } else {
                canvasView.tool = PKEraserTool(eraserType)
            }
        }
    }
    
    var EraserToolBarItems: some View {
        let cornerRadius: CGFloat = 9
        return HStack(spacing: itemSpacing) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(.systemGray5))
                .overlay {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.white)
                            .frame(height: geometry.size.height / 4)
                            .padding(8)
                            .overlay {
                                Group {
                                    switch writingModel.eraserOptions.eraserType {
                                    case .pixel:
                                        Label("Pixel", systemImage: "square.grid.3x3")
                                    case .vector:
                                        Label("Vector", systemImage: "arrow.triangle.2.circlepath")
                                    }
                                }
                                .foregroundColor(Color.black)
                                
                            }
                            .offset(y: writingModel.toggleEraserType ? 0 : geometry.size.height / 2)
                    }
                }
            // TODO: Fixed Width
            //                            .frame(width: toggleWidth)
                .scaleEffect(1.2)
                .frame(width: 100)
                .onTapGesture {
                    withAnimation(.spring()) {
                        writingModel.toggleEraserType.toggle()
                        updateCanvasTool()
                    }
                }
            if writingModel.eraserOptions.eraserType == .pixel {
                VStack(alignment: .center) {
                    Slider(
                        value: $writingModel.eraserOptions.eraserWidth,
                        in: 1...15
                    ) {
                        
                    }
                    .frame(width: 175)
                    Spacer()
                    Circle()
                        .stroke()
                        .fill()
                        .frame(width: writingModel.eraserOptions.eraserWidth, alignment: .center)
                }
            }
        }
    }
    
    var PenToolBarItems: some View {
        VStack(alignment: .center) {
            Slider(
                value: $writingModel.penOptions.inkWidth,
                in: 1...15
            ) {
                
            }
            .frame(width: 175)
            Spacer()
            Circle()
                .frame(width: writingModel.penOptions.inkWidth * 2, alignment: .center)
        }
    }
    
    var body: some View {
        HStack(spacing: itemSpacing) {
            Toggle(isOn: $writingModel.toggleIsOn) {
                
            }
            .toggleStyle(HWToggleStyle(
                topImage: "pencil",
                bottomImage: "eraser"
            ))
            .onChange(of: writingModel.toggleIsOn) { newValue in
                updateCanvasTool()
            }
            
//            Spacer()
            
            switch writingModel.selectedTool {
            case .pen:
                PenToolBarItems
            case .eraser:
                EraserToolBarItems
            }
        }
        .padding(20)
        .padding(.horizontal, 10)
        .frame(width: 500, height: 120, alignment: .leading)
        .background {
            Capsule()
            // TODO: Better colours
                .fill(Color.secondary)
            // FIXME: Hardcoding sizes
                .shadow(radius: 2)
        }
    }
}
