//
//  PracticeView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

/// # Practice View
/// This is the practice view, where users can practice their handwriting skills by making their own special tests and others via a dialog
///
///
struct PracticeView: View {
    /// The size for image items (the square shown at the leading side of each practice item)
    private let gridItemSize: CGFloat = 100

    /// State variable that displays an alert for creating a new practice
    @State private var showNewPracticeAlert = false
    @State private var openPractice = false

    /// Search Term for searching up
    @State private var searchTerm: String = ""
    
    // TODO: Find model data for practice
    @State private var newPracticeName: String = ""

    var body: some View {
            // using if loop to prevent external toolbar rendering twice
            if openPractice {
                NavigationLink(destination: HandWritingView(), isActive: $openPractice) {
                    EmptyView()
                }
            }
            List {
                #if targetEnvironment(simulator)
                    ForEach(0..<100) { _ in
                        NavigationLink {
                            Text("A beast awakens from the shadows, to claim its prey")
                        } label: {
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
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        showNewPracticeAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .alert("New Practice", isPresented: $showNewPracticeAlert) {
                        TextField("Enter Sentence", text: $newPracticeName)
                        Button("Cancel", role: .cancel, action: {})
                        Button("OK") {
                            openPractice = true
                        }
                    } message: {
                        Text("Xcode will print whatever you type.")
                    }
                }
            })
            .padding()
    }
}

#Preview {
    PracticeView()
}

#Preview("View in Dashboard") {
    DashboardView(appActivity: .practice)
}
