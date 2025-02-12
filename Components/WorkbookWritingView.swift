//
//  WorkbookWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//

import SwiftUI

struct WritingController {
    func writing() -> Data? {
        return nil
    }
}

struct WorkbookWritingView: View {
    @Bindable var workBook: Workbook
    
    var writingController: WritingController = WritingController()
    
    @Environment(\.presentationMode) var presentationMode
    
    init(workBook: Workbook) {
        self.workBook = workBook
        self.workBook.lastAccessed = Date()
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            WritingView()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            // save workbook data
                            if let data = writingController.writing() {
                                workBook.data = data
                            }
                            
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
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let workbook: Workbook = .init(name: "Test", data: Data(), lastAccessed: Date())
    WorkbookWritingView(workBook: workbook)
}
