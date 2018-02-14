//
//  InvestigationAPI.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class InvestigationAPI: NSObject {
    
    static let sharedInstance = InvestigationAPI()
    
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
    
    
    
    func getViolationsWithInvestigation(completion: @escaping ([BookInvestigation],Bool)->()){
        
        var violationsArray = [BookInvestigation]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        //                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=DriverFines&ProfileID=25176&CultureId=0
                        
//                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=ListforInvestBooking&ProfileID=7060&CultureId=0
                        
                        let urlString = serviceURL + "/ReadData?AppInstallGUID=\(appInstallGUID)&RequestType=\(listforInvestBooking)&ProfileID=\(profileId)&CultureId=\(cultureIdEN)"
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
                                    completion(violationsArray, false)
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
                                        completion(violationsArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let violation = BookInvestigation()
                                    violation.TRANS_ID = dict["TRANS_ID"] as? Int
                                    violation.TRANS_NO = dict["TRANS_NO"] as? String
                                    violation.TRANS_TYPE = dict["TRANS_TYPE"] as? String
                                    violation.CERT_COMPLAINT_ID = dict["CERT_COMPLAINT_ID"] as? String
                                    violation.TRANS_DATE  = dict["TRANS_DATE"] as? String
                                    violation.STATUS_NAME = dict["STATUS_NAME"] as? String
                                    
                                    violationsArray.append(violation)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(violationsArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(violationsArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(violationsArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(violationsArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(violationsArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(violationsArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(violationsArray, false)
            }
        }
        
    }
    
    
    func fetchInvestigationSchedule(completion: @escaping ([InvestigationSchedule],Bool)->()){
        
        var scheduleArray = [InvestigationSchedule]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        //                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=DriverFines&ProfileID=25176&CultureId=0
                        
                        //                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=ListforInvestBooking&ProfileID=7060&CultureId=0
                        
                        let urlString = serviceURL + "/ReadData?AppInstallGUID=\(appInstallGUID)&RequestType=\(viewInvestSchedule)&ProfileID=\(profileId)&CultureId=\(cultureIdEN)"
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
                                    completion(scheduleArray, false)
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
                                        completion(scheduleArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let schedule = InvestigationSchedule()
                                    schedule.TRANS_ID = dict["TRANS_ID"] as? Int
                                    schedule.TRANS_NO = dict["TRANS_NO"] as? String
                                    schedule.TRANS_TYPE = dict["TRANS_TYPE"] as? String
                                    schedule.INVESTIGATION_CENTRE = dict["INVESTIGATION_CENTRE"] as? String
                                    schedule.TRANS_DATE  = dict["TRANS_DATE"] as? String
                                    schedule.INVESTIGATION_TIME = dict["INVESTIGATION_TIME"] as? String
                                    schedule.STATUS_NAME = dict["STATUS_NAME"] as? String
                                    
                                    scheduleArray.append(schedule)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(scheduleArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(scheduleArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(scheduleArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(scheduleArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(scheduleArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(scheduleArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(scheduleArray, false)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func bookInvestigationAppointment(centerId: String, transId: String,time: String ,completion: @escaping ([BoolInvestigationResponse],Bool)->()){
        
        var bookResponseArray = [BoolInvestigationResponse]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
//http://83.111.121.89:338/LESMOBILEAPI/Masters/BookInvestigation?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&TransId=10234901&ProfileID=1234&InvCentreId=2345&InvestigationTime=2017-02-20T11:30:00
                        
                        let urlString = serviceURL + "/BookInvestigation?AppInstallGUID=\(appInstallGUID)&TransId=\(transId)&ProfileID=\(profileId)&InvCentreId=\(centerId)&InvestigationTime=\(time)"
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
                                    completion(bookResponseArray, false)
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
                                        completion(bookResponseArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let res = BoolInvestigationResponse()
                                    res.SUCCESS = dict["SUCCESS"] as? Int
                                    res.MSG = dict["MSG"] as? String
                                    res.VALID_POSSIBLE_DATE = dict["VALID_POSSIBLE_DATE"] as? Date
                                    
                                    
                                    bookResponseArray.append(res)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(bookResponseArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(bookResponseArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(bookResponseArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(bookResponseArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(bookResponseArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(bookResponseArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(bookResponseArray, false)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
