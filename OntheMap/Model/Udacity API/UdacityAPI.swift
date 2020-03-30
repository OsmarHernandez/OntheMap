//
//  UdacityAPI.swift
//  OntheMap
//
//  Created by Osmar Hernández on 27/03/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

class UdacityAPI {
    static let shared = UdacityAPI()
    
    struct Auth {
        static var objectId = ""
        static var sessionId = ""
        static var expiresAt = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case studentLocation
        case getUserData(String)
        case putStudentLocation(String)
        case update
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .studentLocation:
                return Endpoints.base + "/StudentLocation"
            case .getUserData(let userId):
                return Endpoints.base + "/users/\(userId)"
            case .putStudentLocation(let objectId):
                return Endpoints.base + "/StudentLocation/\(objectId)"
            case .update:
                return Endpoints.base + "/StudentLocation?order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie?
        let sharedCookieStorage = HTTPCookieStorage.shared
    
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(false, error)
                return
            }
            
            Auth.objectId = ""
            Auth.sessionId = ""
            Auth.expiresAt = ""
            completion(true, nil)
        }
        
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            if ResponseType.self == UdacitySessionResponse.self {
                let range = (5..<data.count)
                data = data.subdata(in: range)
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    class func login(_ user: User, completion: @escaping(Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: user)
        
        taskForPOSTRequest(url: Endpoints.session.url, body: body, responseType: UdacitySessionResponse.self) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.expiresAt = response.session.expiration
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func create(studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.studentLocation.url, body: studentLocation, responseType: CreateResponse.self) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func update(objectId: String, studentLocation: StudentLocation, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.putStudentLocation(objectId).url, body: studentLocation, responseType: UpdateResponse.self) { (response, error) in
            if let response = response {
                print(response.updatedAt)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocation.url, responseType: Locations.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getUser(userId: String, completion: @escaping (StudentLocation?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData(userId).url, responseType: StudentLocation.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getUpdate(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.update.url, responseType: Locations.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
}