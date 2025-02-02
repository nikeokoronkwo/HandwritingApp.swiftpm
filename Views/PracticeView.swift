//
//  PracticeView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

struct PracticeView: View {
    private let gridItemSize: CGFloat = 100
    
    var body: some View {
            List {
#if targetEnvironment(simulator)
                ForEach(0..<100) { _ in
                    HStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: gridItemSize, height: gridItemSize)
                        VStack(alignment: .leading) {
                            Text("Placeholder")
                            Text("Placeholder Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
#endif
            }
            .listStyle(.plain)
            .padding()
    }
}

#Preview {
    PracticeView()
}

#Preview("View in Dashboard") {
    DashboardView(appActivity: .practice)
}
