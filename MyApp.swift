import SwiftData
import SwiftUI

/// The application entrypoint
@main
struct MyApp: App {
    /// Whether the user has been onboarded
    @AppStorage("isOnboarded") var userIsOnboarded: Bool = false

    var modelContainer: ModelContainer = {
        //        do {
        let schemas = Schema([
            Workbook.self,
            RealtimeWritingModel.self,
            WritingModel.self,
        ])

        let workBookConfiguration = ModelConfiguration(
            "workbooks",
            schema: Schema([Workbook.self]))

        let writingConfiguration = ModelConfiguration(
            "writing",
            schema: Schema([RealtimeWritingModel.self, WritingModel.self]))

        return try! ModelContainer(
            for: schemas, configurations: [workBookConfiguration, writingConfiguration])
        //        }
        //        catch {
        //            return try! ModelContainer(for: Workbook.self,
        //                                   RealtimeWritingModel.self,
        //                                   WritingData.self)
        //        }
    }()

    /// The Main View one goes to once the application is opened
    ///
    /// In the moment the app is opened, the user is either onboarded, if `userIsOnboarded` is false (meaning that the user is **not** onboarded), or just given options of whether to begin practicing or not
    var body: some Scene {
        WindowGroup {
            if !userIsOnboarded {
                OnboardingView()
            } else {
                DashboardView()
                    .modelContainer(for: [
                        Workbook.self,
                        RealtimeWritingModel.self,
                        WritingModel.self,
                    ])
                //                    .modelContainer(modelContainer)

            }
        }
    }
}
