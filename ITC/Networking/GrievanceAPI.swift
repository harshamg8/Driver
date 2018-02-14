//
//  GrievanceAPI.swift
//  ITC
//
//  Created by Harsha M G on 19/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class GrievanceAPI: NSObject {
    
    static let sharedInstance = GrievanceAPI()
    
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
    
    
    func submitGrievance(type: String, remarks: String, violationId: String , image1Data: [UInt8]?, image2data: [UInt8]?, extension1: String, extension2: String, remarks1: String, remaks2: String, completion: @escaping (Bool,String)->()){
        
//       http://83.111.121.89:338/LESMOBILEAPIMasters/ViolGrievanceSubmit?AppInstallGUID=1B04FF58-95FF-4886-B571-CE58801E1C30&ProfileID=14283&ViolationId=147825&RequestType=48603&Remarks=Test
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        let urlString = "http://83.111.121.89:338/LESMOBILEAPI/Masters/ViolGrievanceSubmit"
                        
                        guard let url = URL(string: urlString) else{
                            DispatchQueue.main.async {
                                completion(false,"")
                            }
                            return
                        }
                        
                        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                        
                        request.httpMethod = "POST"
                        var parameters = [String:Any]()
                        
                        parameters = ["AppInstallGUID":appInstallGUID, "ProfileID": profileId, "ViolationId":violationId, "RequestType":type]
                     
                        if let data1 = image1Data{
                            if data1.count > 0 {
                                
                                parameters.removeAll()
                                //                            let count = data1.count / MemoryLayout<UInt8>.size
                                //                            var array1 = [UInt8](repeating: 0, count: count)
                                //                            data1.copyBytes(to: &array1, count: count * MemoryLayout<UInt8>.size)
                                //                            var byteArray:Array<Any> = Array<Any>()
                                //
                                //                            for i in 0..<count {
                                //                                byteArray.append(NSNumber(value: array1[i]))
                                //                            }
                                parameters = ["AppInstallGUID":appInstallGUID, "ProfileID": profileId, "ViolationId":violationId, "RequestType":type,"Doc_1_Image":data1, "Doc_1_Remarks":remarks1, "Doc_1_Ext":extension1]
                                
                            }
                            
                        }
                        if let data2 = image2data{
                            if(data2.count > 0){
                                
                                parameters.removeAll()
                                //                            let count2 = data2.count / MemoryLayout<UInt8>.size
                                //                            var array2 = [UInt8](repeating: 0, count: count2)
                                //                            data2.copyBytes(to: &array2, count: count2 * MemoryLayout<UInt8>.size)
                                //                            var byteArray2:Array<Any> = Array<Any>()
                                //
                                //                            for i in 0..<count2 {
                                //                                byteArray2.append(NSNumber(value: array2[i]))
                                //                            }
                                parameters = ["AppInstallGUID":appInstallGUID, "ProfileID": profileId, "ViolationId":violationId, "RequestType":type,"Doc_2_Image":data2, "Doc_2_Remarks":remaks2, "Doc_2_Ext":extension2]
                                
                            }

                            
                        }
                        
                        if let data1 = image1Data, let data2 = image2data {
                            
                            if(data1.count > 0 && data2.count > 0){
                                let count1 = data1.count / MemoryLayout<UInt8>.size
                                //                            var array1 = [UInt8](repeating: 0, count: count1)
                                //                            data1.copyBytes(to: &array1, count: count1 * MemoryLayout<UInt8>.size)
                                //                            var byteArray1:Array<Any> = Array<Any>()
                                //
                                //                            for i in 0..<count1 {
                                //                                byteArray1.append(NSNumber(value: array1[i]))
                                //                            }
                                //
                                //                            let count2 = data2.count / MemoryLayout<UInt8>.size
                                //                            var array2 = [UInt8](repeating: 0, count: count2)
                                //                            data2.copyBytes(to: &array2, count: count2 * MemoryLayout<UInt8>.size)
                                //                            var byteArray2:Array<Any> = Array<Any>()
                                //
                                //                            for i in 0..<count2 {
                                //                                byteArray2.append(NSNumber(value: array2[i]))
                                //                            }
                                
                                parameters.removeAll()
                                parameters = ["AppInstallGUID":appInstallGUID, "ProfileID": profileId, "ViolationId":violationId, "RequestType":type,"Doc_1_Image":[1,2,3,4,5,6], "Doc_1_Remarks":remarks1, "Doc_1_Ext":extension1,"Doc_2_Image":[1,2,3,4,5,6], "Doc_2_Remarks":remaks2, "Doc_2_Ext":extension2]
                            }
                            
//
                        }
                        
                        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                            return
                        }

                        request.httpBody = httpBody
                        
                        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.setValue("application/json", forHTTPHeaderField:"Accept")
                        let urlSessionConfiguration = URLSessionConfiguration.default
                        let urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
                        
                        urlSession.dataTask(with: request) { (data, response, error) in
                            
                            if error != nil{
                                print(error ?? "Error")
                                DispatchQueue.main.async {
                                    completion(false,"")
                                }
                                return
                            }
                            do {
                                guard let recievedData = data else {
                                    DispatchQueue.main.async {
                                        completion(false,"")
                                    }
                                    return
                                }
                                if let stringData = String(data: recievedData, encoding: String.Encoding.utf8)  {
                                    print(stringData)
                                    if let httpResponse = response as? HTTPURLResponse {
                                        print("\(httpResponse.statusCode)")
                                    }
                                    
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [String: AnyObject] else {
                                    DispatchQueue.main.async {
                                        completion(false,"")
                                    }
                                    return
                                }
                                
                                if let message = json["Message"] as? String{
                                    DispatchQueue.main.async {
                                        completion(true,message)
                                    }
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                         if let message = json["Message"] as? String{
                                        completion(true,message)
                                        }
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(false,"")
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(false,"")
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(false,"")
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(false,"")
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(false,"")
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(false,"")
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    
}
