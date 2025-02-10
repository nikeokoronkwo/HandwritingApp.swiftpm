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

class LearnModel: ObservableObject {
    @Published var assets: LevelsAsset
    
    init(assets: LevelsAsset) {
        self.assets = assets
    }
}

struct LearnView: View {
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
    
    @StateObject var learnModel: LearnModel = .init(assets: .init(basic: [], advanced: [], expert: []))

    var body: some View {
        TriangularLayout {
            ForEach(options, id: \.name) { opt in
                NavigationLink {
                    // TODO: Levels needs to be passed data somehow
                    LevelsView(type: opt.levelType)
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
        .task {
            
        }
    }
    
    nonisolated func fetchData() async {
        // fetch learn data in background
        let documentsUrl = URL.documentsDirectory.appending(path: "levels")
        
        // save learn data as env object
        // learnModel.assets =
    }
}

#Preview {
    LearnView()
}
