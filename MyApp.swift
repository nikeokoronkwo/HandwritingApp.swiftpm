import SwiftUI

/// The application entrypoint
@main
struct MyApp: App {
    /// Whether the user has been onboarded
    @AppStorage("isOnboarded") var userIsOnboarded: Bool = false

    /// The Main View one goes to once the application is opened
    ///
    /// In the moment the app is opened, the user is either onboarded, if `userIsOnboarded` is false (meaning that the user is **not** onboarded), or just given options of whether to begin practicing or not
    var body: some Scene {
        WindowGroup {
            if !userIsOnboarded {
                OnboardingView()
            } else {
                DashboardView()
            }
        }
    }
}
