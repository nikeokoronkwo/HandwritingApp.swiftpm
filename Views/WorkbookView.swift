//
//  WorkbookView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

struct WorkbookView: View {
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
                ForEach(0..<12) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: gridItemSize, height: gridItemSize)
                        .shadow(radius: 3)
                }
#endif
            }
        }
    }
}

#Preview {
    WorkbookView()
}

#Preview("View in Dashboard") {
    DashboardView(appActivity: .workbook)
}
