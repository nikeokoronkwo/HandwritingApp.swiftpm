//
//  NoteBookBackground.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import SwiftUI

/// Major view for being able to just write down
struct NoteBookBackground: View {
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

/// This works the same as the original ``NoteBookBackground``, but makes it easier to work with text in the given view
struct NoteBookWithTextBackground<V: View>: View {
    var spacing: CGFloat
    var lines: Int
    let lineWidth: CGFloat = 2
    var view: V

    init(spacing: CGFloat, lines: Int, @ViewBuilder _ view: () -> V) {
        self.view = view()
        self.spacing = spacing
        if lines % 2 != 0 {
            self.lines = lines + 1
        } else {
            self.lines = lines
        }
    }

    var LinesView: some View {
        VStack {
            LazyVStack(spacing: spacing) {
                ForEach((1...(lines / 2)).reversed(), id: \.self) { _ in
                    Rectangle()
                        .fill(.cyan)
                        .frame(height: lineWidth)
                }
            }
            view
                .frame(height: spacing, alignment: .top)
            LazyVStack(spacing: spacing) {
                ForEach(((lines / 2) + 1)...lines, id: \.self) { _ in
                    Rectangle()
                        .fill(.cyan)
                        .frame(height: lineWidth)
                }
            }
        }
    }

    var body: some View {
        LinesView
    }
}

#Preview {
    NoteBookBackground(spacing: 30, lines: 10)
}

#Preview {
    NoteBookBackground(spacing: 150, lines: 5)
}

#Preview("NoteBook With Text") {
    NoteBookWithTextBackground(spacing: 150, lines: 4) {
        Text("Yeshuaaaa")
    }
}

#Preview("NoteBook With Special Text") {
    NoteBookWithTextBackground(spacing: 150, lines: 4) {
        Image("Foobar".image(160)!, scale: 1, label: Text("Foobar"))
    }
}
