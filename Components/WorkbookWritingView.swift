//
//  WorkbookWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//

import SwiftUI
import PencilKit

class WritingController: ObservableObject {
    @Published var drawing: PKDrawing?
    
    init(drawing: PKDrawing? = nil) {
        self.drawing = drawing
    }
    
    func writing() -> Data? {
        if let d = drawing {
            return d.dataRepresentation()
        } else {
            return nil
        }
    }
}

struct WorkbookWritingView: View {
    @Bindable var workBook: Workbook
    
    @StateObject var writingController: WritingController = WritingController()
    
    @Environment(\.presentationMode) var presentationMode
    
    init(workBook: Workbook) {
        self.workBook = workBook
        self.workBook.lastAccessed = Date()
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            WritingView(writingController)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            debugPrint(writingController.drawing)
                            // save data
                            if let d = writingController.writing() {
                                workBook.data = d
                            }
                            
                            // go back
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label {
                                Text("Go Back")
                            } icon: {
                                Image(systemName: "chevron.backward")
                            }

                        }

                    }
                }
        }
    }
}

#Preview {
    let workbook: Workbook = .init(name: "Test", data: Data(), lastAccessed: Date())
    WorkbookWritingView(workBook: workbook)
}
