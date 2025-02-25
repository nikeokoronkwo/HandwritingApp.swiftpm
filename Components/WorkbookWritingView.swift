//
//  WorkbookWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//

import PencilKit
import SwiftUI

struct WorkbookWritingView: View {
    @Bindable var workBook: Workbook

    @StateObject var writingController: WritingController

    @Environment(\.dismiss) var dismiss

    init(workBook: Workbook) {
        if let d = workBook.data {
            let drawing = try? PKDrawing(data: d)
            self._writingController = StateObject(
                wrappedValue: WritingController(drawing: drawing) {
                    drawing in
                    // do absolutely nothing
                })
        } else {
            self._writingController = StateObject(
                wrappedValue: WritingController {
                    drawing in
                    // do absolutely nothing
                })
        }

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
                            
                            // save data
                            if let d = writingController.drawing {
                                workBook.data = d.dataRepresentation()
                                workBook.imgData = writingController.imgData
                            }
                            
                            // go back
                            dismiss()
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
