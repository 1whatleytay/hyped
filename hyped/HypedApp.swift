import Hype
import SwiftUI

@main
struct HypedApp: App {
    let hypeController = HypeController()
    
    var body: some Scene {
        WindowGroup {
//            ContentView(hypeController: hypeController)
            MainView()
        }
    }
    
    init() {
        hypeController.use()
        
        // The troubles of static state...
        HypeController.start()
    }
}
