//
//  WorkbookView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftData
import SwiftUI

struct NewWorkbook: Hashable {
    var name: String
}

/// # Workbook View
/// This is the workbook view, where users can make "books" which basically represents free space for users to practice their writing skills on an empty canvas and write. They get to use the same tools they previously used for learning here.
///
/// The workbooks are stored in the user's device (meta stored in persistence, actual workbook files stored in data folder)
struct WorkbookView: View {
    /// The workbooks
    @Query var workbooks: [Workbook]
    @Environment(\.modelContext) private var modelContext

    /// Search Term for searching up a workbook
    @State private var searchTerm: String = ""

    private let gridVSpacing: CGFloat = 40

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
                ForEach(workbooks, id: \.lastAccessed) { wb in
                    NavigationLink(value: wb) {
                        WorkbookItemView(book: wb)
                    }
                }
            }
            .padding()
        }
        // TODO: Implement Searching
        .searchable(text: $searchTerm)
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                NavigationLink(value: NewWorkbook(name: "Untitled")) {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            debugPrint(workbooks)
        }
    }
}

struct WorkbookItemView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    var book: Workbook

    private let size: CGFloat = 220

    var body: some View {
        Group {
            if let data = book.imgData {
                ImageFromData(data)
                    .resizable()
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
            }
        }
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
                        Text("**\(book.name)**")
                            .foregroundStyle(Color.primary)
                        Text(book.lastAccessed.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                }
        }
        .contextMenu {
            Button(role: .destructive) {
                modelContext.delete(book)
            } label: {
                Text("Remove")
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

#Preview("WorkbookView with Swift Data") {
    ModelViewContainer(
        items: {
            let randomNotebooks = [
                "my book",
                "rando book",
                "book 1",
                "untitled",
            ]

            return (1..<10).map { i in
                return Workbook(
                    name: randomNotebooks.randomElement()!, data: Data(),
                    lastAccessed: Date(
                        timeIntervalSinceNow: TimeInterval(Float.random(in: 0..<50.0))))
            }
        }()
    ) {
        DashboardView(appActivity: .workbook)
    }
}
