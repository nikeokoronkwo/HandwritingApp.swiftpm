//
//  WorkbookWritingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 09/02/2025.
//

import SwiftUI

struct WorkbookWritingView: View {
    @Bindable var workBook: Workbook
    
    @Environment(\.presentationMode) var presentationMode
    
    init(workBook: Workbook) {
        self.workBook = workBook
        self.workBook.lastAccessed = Date()
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let workbook: Workbook = .init(name: "Test", data: Data(), lastAccessed: Date())
    WorkbookWritingView(workBook: workbook)
}
