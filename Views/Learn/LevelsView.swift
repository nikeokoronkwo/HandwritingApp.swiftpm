//
//  LevelsView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import SwiftData
import SwiftUI

private func learnPredicate() -> Predicate<WritingModel> {
    return #Predicate<WritingModel> { model in
        model.core
    }
}

struct LevelsView: View {
    @Query(filter: learnPredicate(), sort: \.updated) var levelInfo: [WritingModel]

    /// Search Term for searching up a workbook
    @State private var searchTerm: String = ""

    var type: LevelType

    private let gridVSpacing: CGFloat = 40

    private let gridItemSize: CGFloat = 220

    private var gridItems: [GridItem] {
        return [
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
        ]
    }

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: gridItems,
                alignment: .center,
                spacing: gridVSpacing
            ) {
                #if targetEnvironment(simulator)
                    ForEach(0..<12) { index in
                        NavigationLink {
                            // TODO: Pass data down to handwriting view
                            //                            HandWritingView()
                        } label: {
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: gridItemSize, height: gridItemSize)
                                    .shadow(radius: 4)
                                Text("Level \(index + 1)")
                            }
                        }
                    }
                #endif
            }
            .padding()
        }
        // TODO: Implement Searching
        .searchable(text: $searchTerm)
    }
}

#Preview {
    LevelsView(type: .advanced)
}
