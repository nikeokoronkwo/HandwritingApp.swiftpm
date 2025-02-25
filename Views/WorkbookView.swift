//
//  WorkbookView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftData
import SwiftUI
import PencilKit

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


    private let gridVSpacing: CGFloat = 40

    private var gridItems: [GridItem] {
        return [
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
            GridItem(.flexible(), spacing: nil, alignment: nil),
        ]
    }

    var body: some View {
        if workbooks.isEmpty {
            Text("Workbooks are a great way to free-write and practice text writing on your own. To get started, click on the \"+\" button above!")
                .font(.subheadline)
        } else {
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
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    NavigationLink(value: NewWorkbook(name: "Untitled")) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

/// A view used to displau a workbook item in the given grid
struct WorkbookItemView: View {
    @Environment(\.modelContext) var modelContext
    
    @Environment(\.colorScheme) var colorScheme
    
    var book: Workbook

    private let size: CGFloat = 220

    var body: some View {
        Group {
            if let data = book.imgData ?? (book.data == nil ? nil : try? PKDrawing(data: book.data!).image(from: CGRect(x: 0, y: 0, width: size, height: size), scale: 1).pngData()!) {
                ImageFromData(data)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: size * 0.66, alignment: .top)
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(white: 0.4))
            }
        }
        .frame(width: size, height: size)
        .shadow(radius: 3)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(
                    colorScheme == .dark
                        ? Color(white: 0.2)
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
        .preferredColorScheme(.light)
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
