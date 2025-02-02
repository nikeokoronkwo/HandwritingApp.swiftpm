//
//  OnboardingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

/// The Onboarding View, which is
struct OnboardingView: View {
    /// Whether the user has been onboarded
    @AppStorage("isOnboarded") var userIsOnboarded: Bool?
    
    /// The main body of the view
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Handwriting App!")
                Text("Get started with perfecting your handwriting today")
                HStack(spacing: 20) {
                    Button("Practice") {
                        userIsOnboarded = true
                    }
                }
                .padding(20)
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
