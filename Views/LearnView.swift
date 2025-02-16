//
//  LearnView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

// TODO: Add support for "continue from where you stopped" type shi
struct LearnOption {
    var name: String
    var description: String
    var levelType: LevelType
}

enum LevelType {
    case basic
    case advanced
    case expert
}

extension LevelsAsset {
    func forType(_ type: LevelType) -> Levels {
        switch type {
        case .basic:
            return self.basic
        case .advanced:
            return self.advanced
        case .expert:
            return self.expert
        }
    }
}

struct LearnView: View {
    @Environment(\.levelModel) var levelModel

    private var options: [LearnOption] = [
        LearnOption(
            name: "Foundations", description: "Learn the fundamentals of good handwriting",
            levelType: .basic),
        LearnOption(
            name: "Advanced", description: "Get serious and write practically", levelType: .advanced
        ),
        LearnOption(
            name: "Custom", description: "Try out something new, with no guides", levelType: .expert
        ),
    ]

    var body: some View {
        TriangularLayout {
            ForEach(options, id: \.name) { opt in
                NavigationLink {
                    if levelModel == nil {
                        Text("Loading...")
                    } else {
                        // TODO: Levels needs to be passed data as binding variable
                        //                        let binding = Binding {
                        //
                        //                        } set: { Value in
                        //
                        //                        }

                        LevelsView(type: opt.levelType)
                    }
                } label: {
                    VStack {
                        // TODO: Overlay incase man wanna continue from where he stopped
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 250, height: 200)
                            .shadow(radius: 4)
                        Text(opt.name)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                        Text(opt.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

            }
        }
    }
}

#Preview {
    let demoLevelModel = LevelsModel(assetPath: [:])
    DashboardView(appActivity: .learn)
        .environment(\.levelModel, demoLevelModel)
}

#Preview("Dashboard Preview") {
    EnvironmentObjectViewContainer {
        DashboardView(appActivity: .learn)
    }
}

#Preview("Try with real data") {
    EnvironmentObjectViewContainer {
        LearnView()
    }
}
