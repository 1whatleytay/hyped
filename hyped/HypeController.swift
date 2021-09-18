import Hype
import Foundation

// Probably some .env equivalent for IOS like in Info.plist... god...
let hypeAppID: String = "969f6cb2"
let hypeAccessToken: String = "373e0d803985df37" // please dont push me...

typealias HypeListener = (String) -> Void

// I mean... I just feel sorry writing this...
class HypeController : NSObject, HYPStateObserver, HYPMessageObserver, HYPNetworkObserver {
    // do whatever you want... im not one to stop you
    public var instances = [HYPInstance]()
    public var listeners = [HypeListener]() // my thing
    
    func hypeDidStart() {
        print("Hype has started.")
    }
    
    func hypeDidStopWithError(_ error: HYPError!) {
        
    }
    
    func hypeDidFailStartingWithError(_ error: HYPError!) {
        // probably should just !
        print("Hype error, \(error.description ?? "nil").")
    }
    
    func hypeDidBecomeReady() {
        
    }
    
    func hypeDidRequestAccessToken(withUserIdentifier userIdentifier: UInt) -> String! {
        // Enough for development mode.
        
        return hypeAccessToken
    }
    
    func hypeDidReceive(_ message: HYPMessage!, from fromInstance: HYPInstance!) {
        guard let text = String(data: message.data, encoding: .utf8) else { return }
        
        listeners.forEach({
            listener in listener(text)
        })
    }
    
    func hypeDidFailSendingMessage(
        _ messageInfo: HYPMessageInfo!, to toInstance: HYPInstance!, error: HYPError!) {
        
    }
    
    func hypeDidFind(_ instance: HYPInstance!) {
        // Called when they find another phone running HypeSDK nearby IIRC.
        
        print("Hype found nearby instance \(instance.stringIdentifier ?? "nil").")
        
        HYP.resolve(instance)
    }
    
    func hypeDidLose(_ instance: HYPInstance!, error: HYPError!) {
        print("Hype lost instance \(instance.stringIdentifier ?? "nil")"
              + " with error \(error.description ?? "nil").")
        
        // Set doesn't *seem* to support hashing by reference in Swift... really sad...
        instances.removeAll(where: { $0 === instance })
    }
    
    func hypeDidResolve(_ instance: HYPInstance!) {
        // Successfully connected with some nearby phone!! Let's gooo
        
        print("Hype connected to instance \(instance.stringIdentifier ?? "nil").")
        
        instances.append(instance) // Assuming instance reference is unique...
    }
    
    func hypeDidFailResolving(_ instance: HYPInstance!, error: HYPError!) {
        print("Hype failed to connect to instance \(instance.stringIdentifier ?? "nil")"
                + " with error \(error.description ?? "nil").")
    }
    
    func broadcast(message: String) {
        instances.forEach({
            instance in HYP.send(message.data(using: .utf8), to: instance)
        })
    }
    
    func use() {
        HYP.add(self as HYPStateObserver)
        HYP.add(self as HYPMessageObserver)
        HYP.add(self as HYPNetworkObserver)
    }
    
    static func start() {
        HYP.setAppIdentifier(hypeAppID)
        
        HYP.start()
    }
}
