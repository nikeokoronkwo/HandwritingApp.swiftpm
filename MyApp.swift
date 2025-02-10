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
                // TODO: Investigate multiple model containers/contexts
                    .modelContainer(for: [
                        Workbook.self,
                        RealtimeWritingModel.self,
                        WritingModel.self,
                    ])
                    .task {
                        await loadAssets()
                    }
                //                    .modelContainer(modelContainer)

            }
        }
    }
    
    nonisolated func loadAssets() async {
        // get assets from bundle
        debugPrint(Bundle.main.isLoaded)
        
        guard let levelsBundleUrl = Bundle.main.url(forResource: "levels", withExtension: "json") else {
            // error out
            return
        }
        
        guard let assetsBundleUrls = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: ".") else {
            // error out
            return
        }
        
        debugPrint(levelsBundleUrl)
        
        // load to documents directory
        let documentsUrl = URL.documentsDirectory
        
        debugPrint(documentsUrl)
        
        do {
            guard let levelData = try? String(contentsOf: levelsBundleUrl) else {
                // throw error
                return
            }
            
            guard let levelDataAsJson = try? JSONDecoder().decode(LevelsAsset.self, from: levelData.data(using: .utf8)!) else {
                // throw error
                return
            }
            
            if levelDataAsJson.advanced.count == 0 ||
                levelDataAsJson.basic.count == 0 ||
                levelDataAsJson.expert.count == 0 {
                // throw error
            }
            
            let assetsDataArray = try assetsBundleUrls.map { url in
                return try Data(contentsOf: url)
            }
            
            try levelData.write(to: documentsUrl, atomically: true, encoding: .utf8)
            
            try assetsDataArray.forEach { data in
                try data.write(to: documentsUrl.appending(path: "assets"), options: [.atomic, .completeFileProtection])
            }
        } catch {
            // handle errors
            return
        }
    }
}
