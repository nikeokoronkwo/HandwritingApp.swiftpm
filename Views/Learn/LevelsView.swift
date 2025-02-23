//
//  LevelsView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 02/02/2025.
//

import SwiftData
import SwiftUI

struct LevelNavModel: Hashable {
    var levelIndex: Int
    var levelHash: Int
    var levelType: LevelType
    var title: String
}

struct LevelsView: View {
    @EnvironmentObject var levelModel: LevelsModel

    /// Search Term for searching up a workbook
    @State private var searchTerm: String = ""

    var type: LevelType

    init(type: LevelType) {
        self.type = type
    }

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
                let levels = levelModel.levelAssets.forType(type)
                if !levels.isEmpty {
                    ForEach(levels, id: \.index) { level in
                        NavigationLink(
                            value:
                                //                        CoreWritingView(
                                LevelNavModel(
                                    levelIndex: level.index,
                                    levelHash: level.hashValue,
                                    levelType: type,
                                    title: level.name)
                        ) {
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: gridItemSize, height: gridItemSize)
                                    .shadow(radius: 4)
                                Text(level.name)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                } else {
                    Text("An error occured loading the levels. Please try again")
                }
            }
            .padding()
        }
        // TODO: Implement Searching
        //        .searchable(text: $searchTerm)
    }
}
//
//#Preview {
//    var levels = []
//    LevelsView(type: .advanced, levels: Binding(get: {
//        return levels
//    }, set: { v in
//        levels = v
//    }))
//}

#Preview("Dashboard Preview") {
    EnvironmentObjectViewContainer {
        DashboardView(appActivity: .learn)
    }
}
