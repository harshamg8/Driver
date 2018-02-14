//
//  RegisterWebService.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import Foundation

class RegisterWebService: NSObject {
    
    //Singleton variable
    static let sharedInstance = RegisterWebService()
    
    func registerDevice(completion: @escaping (Bool)->()) {
        
        let urlString = serviceURL + "/RegisterDevice?UserName=LESDRVMOB&UserPwd=Les965DrMb&DeviceID=\(deviceID!)&OS=IOS"
       // let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
        let url = URL(string: urlString)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.httpMethod = "POST"
        
        //httpBody is needed for post method
//        if Method == "POST"
//        {
//            request.httpBody = jsonData
//            request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
//        }
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField:"Accept")
        
        let urlSessionConfiguration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
        
        urlSession.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print(error ?? "Error")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            do
            {
                guard let receivedData = data,  let stringData = String(data: receivedData, encoding: String.Encoding.utf8) else{
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                //Checking for response code whether the response is success or not
                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                {
                    UserProfileDefaults.appInstallGUID = stringData
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
                else //returning
                {
                   // print(stringData)
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
            catch let receivedError as NSError
            {
                print(receivedError.localizedDescription)
                DispatchQueue.main.async {
                    completion(false)
                }
                
            }
        }.resume()
    }
}
