import SwiftUI

// can't find colors i like in Colors.* sooo... tailwift-ui
let gray100 = Color(red: 0.95, green: 0.96, blue: 0.96)
let gray300 = Color(red: 0.82, green: 0.84, blue: 0.86) // no dark mode equivalent >:)
let gray800 = Color(red: 0.12, green: 0.16, blue: 0.22)

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var dark: Bool { colorScheme == .dark }
    
    let hypeController: HypeController?
    
    @State var messages = "[Log Start]"
    
    // I don't know SwiftUI formatting...
    var body: some View {
        VStack() {
            VStack(alignment: .leading) {
                Text("Messages")
                    .padding(.leading, 10)
                    
                VStack() {
                    Text(messages)
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                .padding()
                .background(dark ? gray800 : gray100)
                .border(gray300)
            }

            Button(action: {
                print("Broadcasting...")
                hypeController?.broadcast(message: "Hello World!")
            }) {
                Text("Send")
            }.padding()
        }.onAppear(perform: {
            attachHype(messages: $messages)
        })
    }
    
    // Okay... I've convinced Swift I'm not capturing "mutating self".
    func attachHype(messages: Binding<String>) {
        hypeController?.listeners.append({
            message in
            print("Hype received message \(message).")
            messages.wrappedValue = message
        })
    }
    
    init(hypeController: HypeController?) {
        self.hypeController = hypeController
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(hypeController: nil)
    }
}
