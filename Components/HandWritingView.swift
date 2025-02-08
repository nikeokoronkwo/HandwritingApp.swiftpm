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
    @Binding var model: WritingModel?

    init(model: Binding<WritingModel?>? = nil) {
        self._model = model ?? Binding.constant(nil)
    }

    var body: some View {
        Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HandWritingView()
}
