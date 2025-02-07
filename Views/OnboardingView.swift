//
//  OnboardingView.swift
//  HandWriting
//
//  Created by Nikechukwu Okoronkwo on 01/02/2025.
//

import SwiftUI

struct OnboardingContent {
    var title: String
    var content: AttributedString
}

/// The Onboarding View, which is
struct OnboardingView: View {
    /// Whether the user has been onboarded
    @AppStorage("isOnboarded") var userIsOnboarded: Bool?
    
    /// The onboarding content to show
    private var onboardingContent: [OnboardingContent] = [
        OnboardingContent(title: "Practical Learning", content: "Write with guides and feedback to help you improve your handwriting, while making use of practice exercises to reinforce your skills"),
        OnboardingContent(title: "Check your progress", content: "View stats on how good you're doing, and see what you can improve to make your handwriting spotless")
    ]

    /// The main body of the view
    var body: some View {
        // Onboarding Tabs
        // TODO: Make the UI spectacular
        TabView {
            VStack {
                Text("Welcome to the Handwriting App",
                     comment: "A title saying 'Welcome to the Handwriting App' for new users")
                Text("Becoming good at handwriting is as easy as starting!")
            }
            ForEach(onboardingContent, id: \.title) { content in
                OnboardingContentView(content: content)
            }
        }
        .tabViewStyle(.page)
    }
}

/// An onboarding content view which displays either an image or a video alongside some text
struct OnboardingContentView: View {
    var content: OnboardingContent
    
    var body: some View {
            VStack {
                // image
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 2)
                    .aspectRatio(1.5, contentMode: .fit)
                    .frame(height: 450)
                    
                // text
                Text(content.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding()
                Text(content.content)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: 800)
    }
}

#Preview {
    OnboardingView()
}
