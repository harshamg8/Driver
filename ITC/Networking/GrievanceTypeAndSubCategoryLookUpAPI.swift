//
//  GrievanceTypeAndSubCategoryLookUpAPI.swift
//  ITC
//
//  Created by Harsha M G on 22/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit
import Foundation

class GrievanceTypeAndSubCategoryLookUpAPI: NSObject {
    
    static let sharedInstance = GrievanceTypeAndSubCategoryLookUpAPI()
    
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
    
    func fetchGrievanceTypeLookUps(completion: @escaping ([GrievanceTypeLookUp]?, Bool)->()){
        
        var recievedArray = [GrievanceTypeLookUp]()
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        // http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=ExamCenterLookup&AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45
                        
                        let urlString = serviceURL + "/ReadData?RequestType=\(grievanceTypeLookup)&AppInstallGUID=\(appInstallGUID)"
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
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(recievedArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let grievanceType = GrievanceTypeLookUp()
                                    grievanceType.ID = dict["ID"] as? Int
                                    grievanceType.NAME_AR = dict["NAME_AR"] as? String
                                    grievanceType.NAME_EN = dict["NAME_EN"] as? String
                                    recievedArray.append(grievanceType)
                                }
                                
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
    
    
    func fetchGrievanceSubCategoryLookUps(completion: @escaping ([GrievanceSubcategoryLookUp]?, Bool)->()){
        
        var recievedArray = [GrievanceSubcategoryLookUp]()
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        // http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=ExamCenterLookup&AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45
                        
                        let urlString = serviceURL + "/ReadData?RequestType=\(grievanceSubCatLookup)&AppInstallGUID=\(appInstallGUID)"
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
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(recievedArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let grievanceSubCat = GrievanceSubcategoryLookUp()
                                    grievanceSubCat.ID = dict["ID"] as? Int
                                    grievanceSubCat.NAME_AR = dict["NAME_AR"] as? String
                                    grievanceSubCat.NAME_EN = dict["NAME_EN"] as? String
                                    grievanceSubCat.CATEGORY_ID = dict["CATEGORY_ID"] as? Int
                                    grievanceSubCat.CATEGORY_NAME = dict["CATEGORY_NAME"] as? String
                                    grievanceSubCat.GRIEVANCE_TYPE = dict["GRIEVANCE_TYPE"] as? Int
                                    
                                    recievedArray.append(grievanceSubCat)
                                }
                                
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
    
    func submitGrievance(gId: Int, oId: Int, dict: [[String:Any]], completion: @escaping (Bool)->()){
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                print("\(appInstallGUID)")
                
                //                http://83.111.121.89:338/LESMOBILEAPI/Masters/UpdateMobileNo?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&ProfileId=12485&MobileNo=1234567890
                if let profileId = UserProfileDefaults.profileID {
                    let urlString = "http://83.111.121.89:338/LESMOBILEAPI/Masters/SubmitDriverGrievance"
                    guard let url = URL(string: urlString) else{
                        DispatchQueue.main.async {
                            completion(false)
                        }
                        return
                    }
                    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                    
                    //httpBody is needed for post method
                    //        if Method == "POST"
                    //        {
                    //            request.httpBody = jsonData
                    //            request.setValue("\(jsonData!.count)", forHTTPHeaderField: "Content-Length")
                    //        }
                   
                    request.httpMethod = "POST"
                    
                    let myDictOfDict:[String:Any] = [
                        "AppInstallGUID" :appInstallGUID
                        ,   "ProfileID" : profileId ,
                            "ServiceType" : gId ,
                        "RegionID" : oId ,
                        "Complaints" : dict
                    ]
                    
                    
                    
                    
                    
                    print(myDictOfDict)
                    let jsonTodo: Data
                    do {
                        jsonTodo = try JSONSerialization.data(withJSONObject: myDictOfDict, options: [])
                        request.httpBody = jsonTodo
                    } catch {
                        
                        print("Error: cannot create JSON from todo")
                        DispatchQueue.main.async {
                            completion(false)
                        }
                        return
                    }
                   
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
                            guard let recievedData = data else {
                                DispatchQueue.main.async {
                                    completion(false)
                                }
                                return
                            }
                            if let stringData = String(data: recievedData, encoding: String.Encoding.utf8)  {
                                
                                print(stringData)
                            }
                            //Checking for response code whether the response is success or not
                            if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                            {
                                
                                
                                DispatchQueue.main.async {
                                    completion(true)
                                }
                            }
                            else //returning
                            {
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
                }else{
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
                
            }
            else{
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        else{
            DispatchQueue.main.async {
                completion(false)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
}
