import SwiftData
import SwiftUI

/// The dashboard view, which contains most of the stuff that the user will interact with.
///
/// The dashboard view also acts as the entry for the user to either go
///
struct DashboardView: View {
    // TODO: Categorize Features into a model
    @Environment(\.modelContext) var modelContext

    /// The initialiser is just for the sake of previewing/testing
    init(appActivity: AppActivity? = nil) {
        self.appActivity = appActivity
    }

    /// The selected app activity category
    @State private var appActivity: AppActivity?

    /// Whether to open statistics
    @State private var openStatsSheet: Bool = false

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
            NavigationStack {
                Group {
                    if let appActivity {
                        /// Select given activity to do
                        Group {
                            switch appActivity {
                            case .learn:
                                LearnView()
                            case .practice:
                                PracticeView()
                            case .workbook:
                                WorkbookView()
                            }
                        }
                        .padding(.top, 20)
                        .navigationTitle(appActivity.rawValue)
                    } else {
                        /// Provide sample display to get started
                        ///
                        // TODO: Update this with some better UI and icon
                        Text("Select an activity from the sidebar.")
                            .navigationTitle("Dashboard")
                    }
                }
                .navigationDestination(for: WritingModel.self) { mdl in
                    HandWritingView(model: mdl)
                }
                .navigationDestination(for: LevelType.self, destination: { type in
                    LevelsView(type: type)
                })
                .navigationDestination(
                    for: LevelNavModel.self,
                    destination: { levelNavModel in
                        CoreWritingView(levelNavModel.levelIndex, forType: levelNavModel.levelType, title: levelNavModel.title)
                    })
                .navigationDestination(for: NewPractice.self) { new in
                    // make new practice
                    let newModel = WritingModel(
                        new.name, updated: Date.now, score: 0, core: false, data: new.name)
                    //
                    let _ = modelContext.insert(newModel)
                    //
                    HandWritingView(model: newModel)
                }
                .navigationDestination(for: Workbook.self) { wb in
                    WorkbookWritingView(workBook: wb)
                }
                .navigationDestination(for: NewWorkbook.self) { new in
                    //            // make new workbook
                    let wb = Workbook(name: new.name, lastAccessed: Date.now)
                    let _ = modelContext.insert(wb)
                    //
                    WorkbookWritingView(workBook: wb)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    #if targetEnvironment(simulator)
                        Button {
                            openStatsSheet = true
                        } label: {
                            Label("Stats", systemImage: "chart.bar")
                        }
                    #else
                        settingsMenu
                    #endif
                }
            }
            .sheet(isPresented: $openStatsSheet) {
                StatsView()
            }
        }
    }

    /// The settings menu, indicated by the cogwheel icon at the top right corner of the screen
    /// Might not even be needed
    private var settingsMenu: some View {
        Menu {
            Button {
                openStatsSheet = true
            } label: {
                Label("Stats", systemImage: "chart.bar")
            }
        } label: {
            Image(systemName: "gear")
        }
    }
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

#Preview("DashboardView") {
    DashboardView()
}
