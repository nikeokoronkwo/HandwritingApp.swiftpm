import SwiftData
import SwiftUI



/// The application entrypoint
@main
struct MyApp: App {
    /// Whether the user has been onboarded
    @AppStorage("isOnboarded") var userIsOnboarded: Bool = false
    @StateObject
    var model: LevelsModel = .init()
    

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
            Group {
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
                        .environmentObject(model)
//                      .modelContainer(modelContainer)

                }
            }
            .task {
                await getAssets()
            }
        }
    }
    
    nonisolated func getAssets() async {
        // get assets from bundle
        
        guard let levelsBundleUrl = Bundle.main.url(forResource: "levels", withExtension: "json") else {
            // error out
            return
        }
        
        guard let assetsBundleUrls = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: ".") else {
            // error out
            return
        }
        
        // load to documents directory
        let documentsUrl = URL.documentsDirectory
        
        do {
            guard let levelData = try? String(contentsOf: levelsBundleUrl) else {
                // throw error
                return
            }
            
            guard let levelDataAsJson = try? JSONDecoder().decode(LevelsAsset.self, from: levelData.data(using: .utf8)!) else {
                // throw error
                return
            }
            
            debugPrint(levelData)
            debugPrint(levelDataAsJson)
            
            if levelDataAsJson.advanced.count == 0 ||
                levelDataAsJson.basic.count == 0 ||
                levelDataAsJson.expert.count == 0 {
                // throw error
            }
            
            
            let assetsDataDict = try assetsBundleUrls.reduce(into: [String: Data]()) { partialResult, url in
                partialResult[url.lastPathComponent] = try Data(contentsOf: url)
            }
            
            try levelData.write(to: documentsUrl.appending(path: "levels.json"), atomically: true, encoding: .utf8)
            
            try assetsDataDict.forEach { aDictElement in
                try aDictElement.value.write(to: documentsUrl.appending(path: "assets").appending(path: aDictElement.key), options: [.atomic, .completeFileProtection])
            }
            
            

            await MainActor.run {
                model.jsonPath = documentsUrl.appending(path: "levels.json")
                assetsDataDict.forEach { el in
                    model.assetPath[el.key] = documentsUrl.appending(path: "assets").appending(path: el.key)
                }
                
                debugPrint("+++++++++++++++++")
                debugPrint(model)
                debugPrint(model.assetPath)
                debugPrint(model.jsonPath)
            }
            
        } catch {
            // handle errors
            debugPrint(error)
            debugPrint("*****************")
            return
        }
    }
}
