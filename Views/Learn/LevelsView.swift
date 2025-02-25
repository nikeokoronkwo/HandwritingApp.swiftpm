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

extension LevelType {
    var headerInfo: String {
        switch self {
        case .basic:
            return "For the following, trace the dots over the letters for each text in order to complete it. Make sure that your writing looks like the dotted text."
        case .advanced:
            return """
For the following, trace the dots over the letters for each text in order to complete it. Make sure that your writing looks like the dotted text.
If some part of the view is cut off, then minimize the side bar to complete it.
"""
        case .expert:
            return "Now that you have practiced by tracing, it is time for you to write on your own without any guidance. Try to rewrite the text located at the bottom for each level on the notebook."
        }
    }
}

struct LevelsView: View {
    @EnvironmentObject var levelModel: LevelsModel

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
        Section {
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
                                        .overlay {
                                            Image(level.info.value.image(40), scale: 1, label: Text(level.info.value))
                                        }
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
        } header: {
            Text(type.headerInfo)
        }
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
