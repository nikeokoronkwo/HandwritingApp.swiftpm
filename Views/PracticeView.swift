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

enum PracticeValidity {
    case ok
    case tooLong(String)
    case tooShort
    case unknown
}

struct PracticeMainView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query(filter: predicate(), sort: \.updated, order: .reverse) var practiceModels: [WritingModel]

    /// The size for image items (the square shown at the leading side of each practice item)
    private let gridItemSize: CGFloat = 100

    /// State variable that displays an alert for creating a new practice
    @State private var showNewPracticeAlert = false
    @State private var practiceValidity = PracticeValidity.unknown
    @State private var practiceEntered = false
    @State private var shouldDisplayError = false

    @State private var newPractice = false
    @State private var practice = false
    @State private var model: WritingModel?
    @FocusState private var alertFieldFocused: Bool

    // TODO: Find model data for practice
    @State var newPracticeName: String = "untitled"

    var body: some View {
        //        // using if loop to prevent external toolbar rendering twice
        if practiceModels.isEmpty {
            Text("Practice writing with your own words. To get started, click on the \"+\" button to get started!")
                .font(.subheadline)
        } else {
            List {
                ForEach(practiceModels) { m in
                    NavigationLink(value: m) {
                        HStack(spacing: 20) {
                            RoundedRectangle(cornerRadius: 8)
                            // TODO: Model Placeholder Reference
                                .fill(colorScheme == .dark
                                      ? Color(white: 0.2)
                                      : Color.secondary.opacity(0.15))
                                .shadow(radius: 2.5)
                                .frame(width: gridItemSize, height: gridItemSize)
                                .overlay {
                                    Group {
                                        if m.data.count > 0 {
                                            Image(m.data.image(), scale: 1, label: Text(m.data))
                                                .colorInvert()
                                            
                                        } else {
                                            Rectangle()
                                                .opacity(0)
                                        }
                                    }
                                }
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
                    for index in indexSet {
                        modelContext.delete(practiceModels[index])
                    }
                }
                //            .onMove { indexSet, to in
                //                // move
                //                var mdls = practiceModels
                //
                //                mdls.move(fromOffsets: indexSet, toOffset: to)
                //
                //
                //                for (index, item) in mdls.enumerated() {
                //                    item.orderIndex = index
                //                }
                //            }
                
            }
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
                        if practiceEntered {
                            footnote()
                                .font(.footnote)
                        }
                    }
                    .alert(isPresented: $shouldDisplayError) {
                        Alert(title: Text("Error"), message: footnote(),
                              dismissButton: .cancel(Text("Ok")))
                    }
                }
            })
            .onChange(of: newPracticeName) {
                debugPrint(newPracticeName)
            }
            .padding()
//            .alert("New Practice", isPresented: $showNewPracticeAlert) {
//                TextField("Enter Sentence", text: $newPracticeName)
//                Button("Cancel", role: .cancel, action: {})
//                NavigationLink(value: NewPractice(name: newPracticeName)) {
//                    Text("OK")
//                }
//            } message: {
//                Text("Create a new practice playground.")
//                if practiceEntered {
//                    footnote()
//                        .font(.footnote)
//                }
//            }
//            .alert(isPresented: $shouldDisplayError) {
//                Alert(title: Text("Error"), message: footnote(),
//                      dismissButton: .cancel(Text("Ok")))
//            }
        }
    }
    
    func footnote() -> Text {
        switch practiceValidity {
            case .tooLong(let string):
                return Text("Practice text \"\(string)\" cannot be more than 10 characters long at the moment")
            case .tooShort:
                return Text("Practice text cannot be empty")
            default:
                return Text("")
        }
    }
}

#Preview {
    PracticeView()
}

#Preview("View in Dashboard") {
    DashboardView(appActivity: .practice)
}

#Preview("Preview Practice with SwiftData") {
    ModelViewContainer(
        items: {
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
        }(),
        {
            PracticeView()
        })
}

#Preview("Preview Dashboard with SwiftData") {
    ModelViewContainer(
        items: {
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
        }()
    ) {
        DashboardView(appActivity: .practice)
    }
}
