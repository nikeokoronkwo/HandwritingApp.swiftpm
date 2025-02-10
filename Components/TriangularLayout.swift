//
//  TriangularLayout.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
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
                .applying(
                    CGAffineTransform(
                        rotationAngle: -angle * Double(index)))

            point.x += bounds.midX
            point.y += bounds.midY

            // Place the subview.
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }

}