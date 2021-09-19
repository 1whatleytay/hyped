import Hype
import SwiftUI

let deliciousPizza = "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/delish-homemade-pizza-horizontal-1542312378.png"

@main
struct HypedApp: App {
    @State
    var interface : Interface?
    
    func launch(binding: Binding<Interface?>) {
        let finish : (Interface) -> Void = {
            interface in
            
            print("WHY NOT")
            binding.wrappedValue = interface
            
            interface.use()
            Interface.start()
        }
        
        if !Interface.login(callback: finish) {
            Interface.register(name: "YT Man", picture: deliciousPizza, callback: finish)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if interface != nil {
                    MainView()
                } else {
                    Text("Loading Interface...")
                }
            }.onAppear(perform: {
                self.launch(binding: $interface)
            })
        }
    }
}
