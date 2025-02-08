//
//  WorkbookView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI
import SwiftData

/// # Workbook View
/// This is the workbook view, where users can make "books" which basically represents free space for users to practice their writing skills on an empty canvas and write. They get to use the same tools they previously used for learning here.
///
/// The workbooks are stored in the user's device (meta stored in persistence, actual workbook files stored in data folder)
struct WorkbookView: View {
    /// The workbooks
    @Query var workbooks: [Workbook]
    
    /// Search Term for searching up a workbook
    @State private var searchTerm: String = ""

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
                        NavigationLink {
                            // TODO: Pass data down to handwriting view
                            HandWritingView()
                        } label: {
                            WorkbookItemView(size: gridItemSize)
                        }
                    }
                #else
                    
                #endif
            }
            .padding()
        }
        // TODO: Implement Searching
        .searchable(text: $searchTerm)
        .toolbar(content: {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    // TODO: New Workbook
                    // For more info see ``NoteBookView``
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
    }
}

struct WorkbookItemView: View {
    @Environment(\.colorScheme) var colorScheme

    var size: CGFloat

    init(size: CGFloat) {
        self.size = size
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            // TODO: Model Placeholder Reference
            .fill(Color.white)
            .frame(width: size, height: size)
            .shadow(radius: 3)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(
                        colorScheme == .dark
                            ? Color(UIColor.systemBackground).opacity(0.75)
                            : Color.secondary.opacity(0.15)
                    )
                    .clipShape(
                        .rect(
                            bottomLeadingRadius: 15,
                            bottomTrailingRadius: 15
                        )
                    )
                    .frame(height: size * 0.33)
                    .overlay(alignment: .topLeading) {
                        // TODO: Model Placeholder Reference
                        VStack(alignment: .leading) {
                            Text("**Placeholder Text**")
                                .foregroundStyle(Color.primary)
                            Text("Placeholder Text")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                    }
            }
    }
}

#Preview {
    WorkbookView()
        .preferredColorScheme(.light)
}

#Preview("View in Dashboard") {
    DashboardView(appActivity: .workbook)
}
