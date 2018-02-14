//
//  TrainingAPI.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class TrainingAPI: NSObject {
    
    static let sharedInstance = TrainingAPI()

    
    
    func getAppInstallGUID() -> String? {
        if let appInstallGUID = UserProfileDefaults.appInstallGUID {
            if(appInstallGUID != ""){
                let endIndex = appInstallGUID.index(appInstallGUID.endIndex, offsetBy: -1)
                let truncated = appInstallGUID.substring(to: endIndex)
                let startIndex = truncated.index(truncated.startIndex, offsetBy: 1)
                let a = truncated.substring(from: startIndex)
                return a
            }else{
                return ""
            }
            
        }
        else{
            return ""
        }
    }
    
    
    
    
    func fetchTrainingCertificates(completion: @escaping ([TrainingCertificate], Bool)->()){
        
        fetchDataBasedOnTrainingRequestType(requestType: trnCertificates) { (recievedArray,isCompleted)  in
            var certArray = [TrainingCertificate]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let obj = TrainingCertificate()
                        if let d = dict as? [String:AnyObject] {
                            
                            obj.COURSE_NAME_EN = d["COURSE_NAME_EN"] as? String
                            obj.COURSE_NAME_AR = d["COURSE_NAME_AR"] as? String
                            obj.CHAPTER_ID = d["CHAPTER_ID"] as? Int
                            obj.CHAPTER_CODE = d["CHAPTER_CODE"] as? Int
                            obj.CHAPTER_NAME_EN = d["CHAPTER_NAME_EN"] as? String
                            obj.VALIDITY = d["VALIDITY"] as? String
                            obj.CHAPTER_NAME_AR = d["CHAPTER_NAME_AR"] as? String
                            certArray.append(obj)
                            
                        }
                    }
                    DispatchQueue.main.async {
                        completion(certArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(certArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(certArray,false)
                }
            }
        }
    }
    
    
    func fetchRequiredTraining(completion: @escaping ([REquiredTraining], Bool)->()){
        
        fetchDataBasedOnTrainingRequestType(requestType:trainingReq ) { (recievedArray,isCompleted)  in
            var reqArray = [REquiredTraining]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let obj = REquiredTraining()
                        if let d = dict as? [String:AnyObject] {
                            
                            obj.TRAINING_SOURCE_TYPE_ID = d["TRAINING_SOURCE_TYPE_ID"] as? Int
                            obj.TRAINING_SOURCE_EN = d["TRAINING_SOURCE_EN"] as? String
                            obj.TRAINING_SOURCE_AR = d["TRAINING_SOURCE_AR"] as? String
                            obj.COURSE_CODE = d["COURSE_CODE"] as? Int
                            obj.COURSE_NAME_EN = d["COURSE_NAME_EN"] as? String
                            obj.COURSE_NAME_AR = d["COURSE_NAME_AR"] as? String
                            obj.CHAPTER_ID = d["CHAPTER_ID"] as? Int
                            obj.CHAPTER_CODE = d["CHAPTER_CODE"] as? Int
                            obj.CHAPTER_NAME_EN = d["CHAPTER_NAME_EN"] as? String
                            obj.CHAPTER_NAME_AR = d["CHAPTER_NAME_AR"] as? String
                            obj.SUSPENSION_DATE = d["SUSPENSION_DATE"] as? String
                            obj.IS_SUSPENDED = d["IS_SUSPENDED"] as? Int
                            
                            if let b = d["REQUIRED_BEFORE"]{
                                obj.REQUIRED_BEFORE = b as? String
                            }
                            
                            if let a = d["SUSPENSION_STATUS"]{
                                 obj.SUSPENSION_STATUS = a as? String
                            }
                           
                           
                            reqArray.append(obj)
                            
                        }
                    }
                    DispatchQueue.main.async {
                        completion(reqArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(reqArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(reqArray,false)
                }
            }
        }
    }
    
    
    
    func fetchTrainingSchedule(completion: @escaping ([TrainingSchedule], Bool)->()){
        
        fetchDataBasedOnTrainingRequestType(requestType:trainingSchedule ) { (recievedArray,isCompleted)  in
            var scheduleArray = [TrainingSchedule]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let obj = TrainingSchedule()
                        if let d = dict as? [String:AnyObject] {
                            
                            obj.COURSE_NAME_EN = d["COURSE_NAME_EN"] as? String
                            obj.COURSE_NAME_AR = d["COURSE_NAME_AR"] as? String
                            obj.CHAPTER_ID = d["CHAPTER_ID"] as? Int
                            obj.CHAPTER_CODE = d["CHAPTER_CODE"] as? Int
                            obj.CHAPTER_NAME_EN = d["CHAPTER_NAME_EN"] as? String
                            obj.SCHEDULE_DATE = d["SCHEDULE_DATE"] as? String
                            obj.COURSE_CODE = d["COURSE_CODE"] as? Int
                            obj.CHAPTER_NAME_AR = d["CHAPTER_NAME_AR"] as? String
                            scheduleArray.append(obj)
                            
                        }
                    }
                    DispatchQueue.main.async {
                        completion(scheduleArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(scheduleArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(scheduleArray,false)
                }
            }
        }
    }
    
    
    
    
    
    func fetchDataBasedOnTrainingRequestType(requestType: String , completion: @escaping ([AnyObject]?, Bool)->()){
        
        var recievedArray = [AnyObject]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                       
//                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=TrnCertificates&ProfileID=10098
                        
                        
                        let urlString = serviceURL + "/ReadData?AppInstallGUID=\(appInstallGUID)&RequestType=\(requestType)&ProfileID=\(profileId)"
                      
                        
                        let url = URL(string: urlString)
                        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                        request.httpMethod = "GET"
                        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.setValue("application/json", forHTTPHeaderField:"Accept")
                        let urlSessionConfiguration = URLSessionConfiguration.default
                        let urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
                        
                        urlSession.dataTask(with: request) { (data, response, error) in
                            
                            if error != nil{
                                print(error ?? "Error")
                                DispatchQueue.main.async {
                                    completion(recievedArray, false)
                                }
                                return
                            }
                            
                            
                            do {
                                guard let recievedData = data else {
                                    return
                                }
                                if let stringData = String(data: recievedData, encoding: String.Encoding.utf8)  {
                                    print(stringData)
                                    
                                }else{
                                    DispatchQueue.main.async {
                                        completion(recievedArray, false)
                                    }
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(recievedArray, false)
                                    }
                                    return
                                }
                                
                                recievedArray = json as [AnyObject]
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(recievedArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(recievedArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(recievedArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(recievedArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(recievedArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(recievedArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(recievedArray, false)
            }
        }
    }
    
    
    
    
}
