//
//  WorkbookWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//

import PencilKit
import SwiftUI

class WritingController: ObservableObject {
    @Published var drawing: PKDrawing?
    @Published var imgData: Data?

    init(drawing: PKDrawing? = nil, img: Data? = nil) {
        self.drawing = drawing
        self.imgData = img
    }
}

struct WorkbookWritingView: View {
    @Bindable var workBook: Workbook

    @StateObject var writingController: WritingController = WritingController()

    @Environment(\.presentationMode) var presentationMode

    init(workBook: Workbook) {
        self.workBook = workBook
        self.workBook.lastAccessed = Date()

        if let d = workBook.data {
            let drawing = try? PKDrawing(data: d)
            self._writingController = StateObject(wrappedValue: WritingController(drawing: drawing))
        } else {
            self._writingController = StateObject(wrappedValue: WritingController())
        }
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
                            if let d = writingController.drawing {
                                workBook.data = d.dataRepresentation()
                                workBook.imgData = writingController.imgData
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
