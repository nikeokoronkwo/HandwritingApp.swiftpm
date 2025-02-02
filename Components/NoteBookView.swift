//
//  NoteBookView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import SwiftUI

/// Major view for being able to just write down
struct NoteBookView: View {
    var spacing: CGFloat
    var lines: Int
    let lineWidth: CGFloat = 2
    
    var LinesView: some View {
        LazyVStack(spacing: spacing) {
            ForEach((1...lines).reversed(), id: \.self) { _ in
                Rectangle()
                    .fill(.cyan)
                    .frame(height: lineWidth)
            }
        }
        .padding([.top, .bottom], 5)
//        .scrollTransition { content, phase in
//            content
//                .hueRotation(.degrees(45 * phase.value))
//        }
    }
    
    var body: some View {
        if lines * (Int(spacing + lineWidth)) + 10 > Int(UIScreen.main.bounds.size.height) {
            ScrollView {
                LinesView
            }
        } else {
            LinesView
        }
    }
}

#Preview {
    NoteBookView(spacing: 30, lines: 10)
}
