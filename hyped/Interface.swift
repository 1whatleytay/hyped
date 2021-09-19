import Hype
import SwiftUI
import Foundation

// Probably some .env equivalent for IOS like in Info.plist... god...
let hypeAppID: String = "969f6cb2"
let hypeAccessToken: String = "373e0d803985df37" // please dont push me...

typealias HypeListener = (String) -> Void

let userKey = "auth:user-id"

let baseURL = "http://35.222.83.199:8080"

struct RegisterInput : Codable {
    var name: String
    var picture: String
}

struct RateInput : Codable {
    var subjectId: UInt
    var objectId: UInt
    
    var score: Int
}

struct Person : Codable, Hashable {
    var id: UInt
    
    var name: String
    var score: Int
    var picture: String?
    
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case score = "Score"
        case picture = "Picture"
        
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
    }
    
    static func get(userId: UInt, callback: @escaping (Person) -> Void) {
        let url = URL(string: "\(baseURL)/profile?id=\(userId)")! // too lazy to use proper encoding...
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard let data = data else {
                print("Person.get request error \(error?.localizedDescription ?? "nil").")
                return
            }
            
            let decoder = JSONDecoder()
            guard let person = try? decoder.decode(Person.self, from: data) else {
                print("Person.get decoding error.")
                return
            }
            
            callback(person)
        }.resume()
    }
}

struct InterfacePair : Hashable {
    let instance: HYPInstance?
    let person: Person
}

class Interface : NSObject, HYPStateObserver, HYPMessageObserver, HYPNetworkObserver {
    let user: Person
    
    public var nearby: Binding<[InterfacePair]>?
    
    // do whatever you want... im not one to stop you
    public var listeners = [HypeListener]() // my thing
    
    func hypeDidStart() {
        print("Hype has started.")
    }
    
    func hypeDidStopWithError(_ error: HYPError!) {
        // probably should just !
        print("Hype error, \(error.description ?? "nil").")
    }
    
    func hypeDidFailStartingWithError(_ error: HYPError!) {
        // probably should just !
        print("Hype error, \(error.description ?? "nil").")
    }
    
    func hypeDidFailSendingMessage(
        _ messageInfo: HYPMessageInfo!, to toInstance: HYPInstance!, error: HYPError!) {
        // probably should just !
        print("Hype error, \(error.description ?? "nil").")
    }
    
    func hypeDidFailResolving(_ instance: HYPInstance!, error: HYPError!) {
        print("Hype failed to connect to instance \(instance.stringIdentifier ?? "nil")"
                + " with error \(error.description ?? "nil").")
    }
    
    func hypeDidBecomeReady() {
        
    }
    
    func hypeDidRequestAccessToken(withUserIdentifier userIdentifier: UInt) -> String! {
        // Enough for development mode.
        
        return hypeAccessToken
    }
    
    func hypeDidReceive(_ message: HYPMessage!, from fromInstance: HYPInstance!) {
        guard let text = String(data: message.data, encoding: .utf8) else { return }
        guard let id = UInt(text) else { return }
        
        print("Received UID from nearby connection \(fromInstance.stringIdentifier ?? "nil").")
        
        Person.get(userId: id, callback: {
            person in self.nearby?.wrappedValue.append(InterfacePair(instance: fromInstance, person: person))
        })
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
        nearby?.wrappedValue.removeAll(where: { $0.instance === instance })
    }
    
    func hypeDidResolve(_ instance: HYPInstance!) {
        // Successfully connected with some nearby phone!! Let's gooo
        
        print("Hype connected to instance \(instance.stringIdentifier ?? "nil")... sending UID.")
        
        HYP.send(String(user.id).data(using: .utf8), to: instance)
    }
    
    func begin(binding: Binding<[InterfacePair]>) {
        self.nearby = binding
        
        HYP.add(self as HYPStateObserver)
        HYP.add(self as HYPMessageObserver)
        HYP.add(self as HYPNetworkObserver)
        
        HYP.setAppIdentifier(hypeAppID)
        
        HYP.start()
    }
    
    func rate(userId: UInt, score: Int, callback: @escaping (Person) -> Void) {
        let url = URL(string: "\(baseURL)/rate")!
        
        let rateInput = RateInput(subjectId: user.id, objectId: userId, score: score)
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(rateInput) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            guard let data = data else {
                print("Interface.rate request error \(error?.localizedDescription ?? "nil").")
                return
            }
        
            let decoder = JSONDecoder()
            guard let person = try? decoder.decode(Person.self, from: data) else {
                print("Interface.rate decoding error.")
                return
            }
            
            callback(person)
        }.resume()
    }
    
    static func register(name: String, picture: String, callback: @escaping (Interface) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        
        let registerInput = RegisterInput(name: name, picture: picture)
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(registerInput) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            guard let data = data else {
                print("Interface.regsiter request error \(error?.localizedDescription ?? "nil").")
                return
            }
        
            let decoder = JSONDecoder()
            guard let person = try? decoder.decode(Person.self, from: data) else {
                print("Interface.register decoding error.")
                return
            }
            
            UserDefaults.standard.set(String(person.id), forKey: userKey)
            
            // GO BACK!!!!
            callback(Interface(user: person))
        }.resume()
    }
    
    static func login(callback: @escaping (Interface) -> Void) -> Bool {
        guard let value = UserDefaults.standard.string(forKey: userKey) else {
            return false
        }
        
        guard let userId = UInt(value) else {
            return false
        }
        
        Person.get(userId: userId, callback: {
            person in

            callback(Interface(user: person))
        })

        return true
    }
    
    init(user: Person) {
        self.user = user
    }
}
