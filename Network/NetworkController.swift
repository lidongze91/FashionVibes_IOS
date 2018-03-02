//
//  NetworkController.swift
//  FashionApp
//
//  Created by Dongze Li on 2/21/18.
//  Copyright © 2018 Dongze Li. All rights reserved.
//

import Foundation
class NetworkController {
    typealias JSONDictionary = [String: Any]
    typealias tokenResult = (String) -> ()
    //typealias userInfo = ([String]) -> ()
    typealias userInfo = ([String: String]) -> ()
    static let userProfileURL_post = ""
    // string for user token via login function
    var userToken = ""
    // user info via loading user info function
    var email = ""
    var name = ""
    var bio = ""
    var web = ""
    var full_name = ""
    var userInfoDict : [String: String] = [:]
    func load(_ urlString: String, withCompletion completion: @escaping ([Any]?) -> Void) {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                completion(nil)
                return
            }
            let result: [Any]
            switch urlString {
            case NetworkController.userProfileURL_post:
                result = [] // Transform JSON into Question values
//            case NetworkController.usersURL:
//                result = [] // Transform JSON into Question values
            default:
                result = []
            }
            completion(result)
        })
        task.resume()
    }
    func signup(_ url: String, user_info: [String : String]) {
        let urlNSURL = NSURL(string: url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: urlNSURL as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: user_info, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
        }
        task.resume()
    }
    // http request for login
    // post username and password to api and return a proper token
    func login(_ url: String, login_info: [String : String], completion: @escaping tokenResult){
        let urlNSURL = NSURL(string: url)!
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = NSMutableURLRequest(url: urlNSURL as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: login_info, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            else if let data = data {
                // parse the data
                self.parseData(data)
                DispatchQueue.main.async {
                    completion(self.userToken)
                }
            }
        }
        task.resume()
    }
    func getUserInfo(_ url: String, token: String, completion: @escaping userInfo) {
        let urlNSURL = NSURL(string: url)!
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let request = NSMutableURLRequest(url: urlNSURL as URL)
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: login_info, options: [])
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            else if let data = data {
                print(data.description)
                // parse the data
                self.parseUserInfo(data)
                DispatchQueue.main.async {
                    completion(self.userInfoDict)
                }
            }
        }
        task.resume()
    }
    func parseUserInfo(_ data: Data) {
        var response: JSONDictionary?
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            print(response?.description)
        } catch let parseError as NSError {
            print ("JSONSerialization error: \(parseError.localizedDescription)\n")
            return
        }
        guard let email = response!["email"] as? String else {
            print("Dictionary does not contain results key\n")
            return
        }
        self.email = email
        guard let name = response!["name"] as? String else {
            print("Dictionary does not contain results key\n")
            return
        }
        self.name = name
        guard let bio = response!["bio"] as? String else {
            print("Dictionary does not contain results key\n")
            return
        }
        self.bio = bio
        guard let web = response!["web"] as? String else {
            print("Dictionary does not contain results key\n")
            return
        }
        self.web = web
        guard let full_name = response!["full_name"] as? String else {
            print("Dictionary does not contain results key\n")
            return
        }
        self.full_name = full_name
        userInfoDict["email"] = email
        userInfoDict["name"] = name
        userInfoDict["bio"] = bio
        userInfoDict["web"] = web
        userInfoDict["full_name"] = full_name
    }
    // parse the token data from login
    func parseData(_ data: Data) {
        var response: JSONDictionary?
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            print ("JSONSerialization error: \(parseError.localizedDescription)\n")
            return
        }
        
        guard let token = response!["token"] as? String else {
            print("Dictionary does not contain results key\n")
            return
        }
        //print("Parse data token: " + token)
        userToken = token
        print(userToken)
    }
}
    

