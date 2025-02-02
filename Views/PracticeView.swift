//
//  PracticeView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

struct PracticeView: View {
    var body: some View {
        Text("Practice View")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Shoot My Foot") {
                        
                    }
                }
            }
    }
}

#Preview {
    PracticeView()
}

#Preview("View in Dashboard") {
    DashboardView(appActivity: .practice)
}
