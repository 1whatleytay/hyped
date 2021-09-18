import Foundation

let userKey = "auth:user-id"

let baseURL = "http://google.com"

struct RegisterInput : Codable {
    var name: String
    var picture: String
}

struct RateInput : Codable {
    var subjectId: UInt
    var objectId: UInt
    
    var score: Int
}

struct Person : Codable {
    var ID: UInt
    
    var Name: String
    var Score: Int
    var Picture: String
    
    var CreatedAt: String?
    var UpdatedAt: String?
    
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
        }
    }
}

struct Interface {
    let userId: UInt
    
    func rate(userId: UInt, score: Int, callback: @escaping (Person) -> Void) {
        let url = URL(string: "\(baseURL)/rate")!
        
        let rateInput = RateInput(subjectId: self.userId, objectId: userId, score: score)
        
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
        }
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
            data, response, error in
            
            guard let data = data else {
                print("Interface.regsiter request error \(error?.localizedDescription ?? "nil").")
                return
            }
        
            let decoder = JSONDecoder()
            guard let person = try? decoder.decode(Person.self, from: data) else {
                print("Interface.register decoding error.")
                return
            }
            
            UserDefaults.standard.set(String(person.ID), forKey: userKey)
            
            // GO BACK!!!!
            callback(Interface(userId: person.ID))
        }
    }
    
    init?() {
        // :(
        guard let value = UserDefaults.standard.string(forKey: userKey) else {
            return nil
        }
        
        guard let value = UInt(value) else {
            return nil
        }
        
        self.init(userId: value)
    }
    
    init(userId: UInt) {
        self.userId = userId
    }
}
