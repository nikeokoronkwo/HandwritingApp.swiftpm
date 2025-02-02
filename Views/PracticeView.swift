//
//  PracticeView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

/// # Practice View
/// This is the practice view, where users can practice their handwriting skills
struct PracticeView: View {
    /// The size for image items (the square shown at the leading side of each practice item)
    private let gridItemSize: CGFloat = 100
    
    /// Search Term for searching up 
    @State private var searchTerm: String = ""
    
    var body: some View {
            List {
#if targetEnvironment(simulator)
                ForEach(0..<100) { _ in
                    HStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 8)
                        // TODO: Model Placeholder Reference
                            .fill(Color.white)
                            .shadow(radius: 2.5)
                            .frame(width: gridItemSize, height: gridItemSize)
                        VStack(alignment: .leading) {
                            Text("Placeholder")
                            Text("Placeholder Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    // remove
                }
                .onMove { indexSet, to in
                    // move 
                }
#endif
                
            }
        // TODO: Implement Searching
            .searchable(text: $searchTerm)
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
