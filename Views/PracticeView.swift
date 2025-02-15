//
//  PracticeView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftData
import SwiftUI

private func predicate() -> Predicate<WritingModel> {
    return #Predicate<WritingModel> { model in
        !model.core
    }
}

struct NewPractice: Hashable {
    var name: String
}

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale(identifier: "en_US")

    return dateFormatter.string(from: date)
}

/// # Practice View
/// This is the practice view, where users can practice their handwriting skills by making their own special tests and others via a dialog
///
///
struct PracticeView: View {
    var body: some View {
        PracticeMainView()
    }
    
    
//        .navigationDestination(for: WritingModel.self) { m in
////            m.updated = Date()
//            
//        }
//        .navigationDestination(for: String.self) { title in
//            
//        }
//        // TODO: Implement full screen cover for all features
        
}

struct PracticeMainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: predicate(), sort: \.updated, order: .reverse) var practiceModels: [WritingModel]

    /// The size for image items (the square shown at the leading side of each practice item)
    private let gridItemSize: CGFloat = 100

    /// State variable that displays an alert for creating a new practice
    @State private var showNewPracticeAlert = false
    
    @State private var newPractice = false
    @State private var practice = false
    @State private var model: WritingModel?

    /// Search Term for searching up
    @State private var searchTerm: String = ""

    // TODO: Find model data for practice
    @State private var newPracticeName: String = ""

    var body: some View {
        //        // using if loop to prevent external toolbar rendering twice
        List {
            ForEach(practiceModels) { m in
                NavigationLink(value: m) {
                    HStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 8)
                        // TODO: Model Placeholder Reference
                            .fill(Color.white)
                            .shadow(radius: 2.5)
                            .frame(width: gridItemSize, height: gridItemSize)
                        VStack(alignment: .leading) {
                            Text(m.title ?? m.data)
                            Text(formatDate(m.updated))
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
                    NavigationLink(value: NewPractice(name: newPracticeName)) {
                        Text("OK")
                    }
                } message: {
                    Text("Create a new practice playground.")
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

#Preview("Preview Practice with SwiftData") {
    ModelViewContainer(items: {
        let randomWords = [
            "ballotelli",
            "many",
            "My name is Jason",
            "desperate",
            "The man is running",
            "Someone's Watching",
            "Placeholder",
        ]
        return (1..<10).map { i in
            return WritingModel(
                updated: Date(), score: Float.random(in: 1...100), core: false,
                data: randomWords.randomElement()!, result: nil)
        }
    }(), {
        PracticeView()
    })
}

#Preview("Preview Dashboard with SwiftData") {
    ModelViewContainer(items: {
        let randomWords = [
            "ballotelli",
            "many",
            "My name is Jason",
            "desperate",
            "The man is running",
            "Someone's Watching",
            "Placeholder",
        ]
        return (1..<10).map { i in
            return WritingModel(
                updated: Date(), score: Float.random(in: 1...100), core: false,
                data: randomWords.randomElement()!, result: nil)
        }
    }()) {
        DashboardView(appActivity: .practice)
    }
}
