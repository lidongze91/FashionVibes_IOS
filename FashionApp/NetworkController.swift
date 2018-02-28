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
    typealias TokenResult = (String) -> ()
    static let userProfileURL_post = ""
    var userToken = ""
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
    func data_request(_ url: String, user_info: [String : String]) {
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
    func login(_ url: String, login_info: [String : String], completion: @escaping TokenResult){
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
    

