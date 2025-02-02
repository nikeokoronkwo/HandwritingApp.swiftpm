import SwiftUI

/// The Main View one goes to once the application is opened
///
/// In the moment the app is opened, the user is either onboarded, if `userIsOnboarded` is false (meaning that the user is **not** onboarded), or just given options of whether to begin practicing or not
struct HomeView: View {

    /// The main body of the view
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Handwriting App!")
                Text("Get started with perfecting your handwriting today")
                HStack(spacing: 20) {
                    NavigationLink(destination: Text("Hola")) {
                        Text("Practice")
                    }
                    Button("Practice") {

                    }
                }
                .padding(20)
                .padding(.horizontal, 10)
            }
        }
    }
}

/// The dashboard view, which contains most of the stuff that the user will interact with.
///
/// The dashboard view also acts as the entry for the user to either go
///
struct DashboardView: View {

    /// The selected app activity category
    @State private var appActivity: AppActivity? = nil

    /// Whether the side bar view is visible
    @State private var sideViewIsVisible = NavigationSplitViewVisibility.automatic

    // TODO: Break down view: either the dashboard view becomes an encapsulating view, or the items displace into separate views
    var body: some View {
        // Nav Split View when in iPadOS
        NavigationSplitView(columnVisibility: $sideViewIsVisible) {
            // Application Dashboard Sidebar to select options
            List(AppActivity.allCases, id: \.rawValue, selection: $appActivity) { activity in
                NavigationLink(value: activity) {
                    // TODO: Animations on change of item
                    HStack {
                        Image(systemName: activity.icon)
                        Text(activity.rawValue)
                    }
                }
            }
            .navigationTitle("Explore")
        } detail: {
            Group {
                if let appActivity {
                    /// Select given activity to do
                    Group {
                        switch appActivity {
                        case .learn:
                            Text("You selected: \(appActivity)")
                        case .practice:
                            Text("You selected: \(appActivity)")
                        case .workbook:
                            Text("You selected: \(appActivity)")
                        }
                    }
                    .navigationTitle(appActivity.rawValue)
                } else {
                    /// Provide sample display to get started
                    ///
                    /// TODO: Update this with some better UI and icon
                    Text("Select an activity from the sidebar.")
                        .navigationTitle("Dashboard")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    settingsMenu
                }
            }
        }
    }

    /// The settings menu, indicated by the cogwheel icon at the top right corner of the screen
    private var settingsMenu: some View {
        Menu {
            Button {

            } label: {
                Label("Stats", systemImage: "chart.bar")
            }
            Button {

            } label: {
                Label("Open Settings", systemImage: "gear")
            }
        } label: {
            Image(systemName: "gear")
        }
    }
}

/// # App Activity
/// This enum is used to denote the given activity the user is doing on th
enum AppActivity: String, CaseIterable {
    case learn = "Learn"
    case practice = "Practice"
    case workbook = "Workbook"
}

extension AppActivity {
    /// Get the system image icon associated with the given `AppActivity`
    var icon: String {
        switch self {
        case .learn:
            return "pencil"
        case .practice:
            return "note.text"
        case .workbook:
            return "book.closed"
        }
    }
}

#Preview {
    DashboardView()
}
