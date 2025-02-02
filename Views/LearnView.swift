//
//  LearnView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

struct TriangularLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        // Place the views within the bounds.
        let radius = min(bounds.size.width, bounds.size.height) / 3.0


        guard subviews.count == 3 else { return }
        
        let angle = Angle.degrees(360.0 / Double(subviews.count)).radians

        for (index, subview) in subviews.enumerated() {
            var point = CGPoint(x: 0, y: -radius)
                .applying(CGAffineTransform(
                    rotationAngle: -angle * Double(index)))

            
            point.x += bounds.midX
            point.y += bounds.midY

            // Place the subview.
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
    
}

// TODO: Add support for "continue from where you stopped" type shi
struct LearnOption {
    var name: String
    var description: String
}

struct LearnView: View {
    private var options: [LearnOption] = [
        LearnOption(name: "Foundations", description: "Learn the fundamentals of good handwriting"),
        LearnOption(name: "Advanced", description: "Get serious and write practically"),
        LearnOption(name: "Custom", description: "Try out something new, with no guides")
    ]
    var body: some View {
        TriangularLayout {
            ForEach(options, id: \.name) { opt in
                NavigationLink {
                    // TODO: Levels needs to be passed data somehow
                    LevelsView()
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
    LearnView()
}
