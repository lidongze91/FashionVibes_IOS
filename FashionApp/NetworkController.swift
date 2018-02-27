//
//  NetworkController.swift
//  FashionApp
//
//  Created by Dongze Li on 2/21/18.
//  Copyright © 2018 Dongze Li. All rights reserved.
//

import Foundation
class NetworkController {
    static let userProfileURL_post = ""
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
    class func data_request(_ url: String, user_info: [String : String]) {
        let urlNSURL = NSURL(string: url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: urlNSURL as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: user_info, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let paramString = "data=Hello"
//        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
        }
        task.resume()
    }
    //let user_info = ["email": emailTxt.text!, "name": usernameTxt.text!,
    //                 "password": passwordTxt.text!, "bio": bioTxt.text!,
    //                 "web": webTxt.text!, "full_name": fullnameTxt.text!]
    //let signUpEndPoint = URL(string: "http://127.0.0.1:8080/api/profile/")
    //var request = URLRequest(url: signUpEndPoint!)
    //request.httpMethod = "POST"
    //request.httpBody = try? JSONSerialization.data(withJSONObject: user_info, options: [])
    //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
}
    

