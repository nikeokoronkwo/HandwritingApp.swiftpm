//
//  HandWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

struct HandWritingView: View {
    /// The writing model for the given view, if any
    /// Used for populating existing data
    @Bindable var model: WritingModel
    
    init(model: WritingModel) {
        self.model = model
        self.model.updated = Date()
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

struct HandWritingCoreView: View {
    /// The writing model for the given view, if any
    /// Used for populating existing data
    @Bindable var model: WritingModel
    
    
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

#Preview("Practice HW View") {
    let model = WritingModel(updated: Date(), score: 30, core: false, data: "my hands")
    HandWritingView(model: model)
}
