//
//  APIService.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//
import UIKit

class APIService: NSObject {
  
    static let sharedInstance = APIService()
    
    func getProfileIdFromService(permitNumber: String, dob: String, completion: @escaping (Bool)->()){
        if let appInstallGUID = getAppInstallGUID() {
            
            if(appInstallGUID != ""){
                print("\(appInstallGUID)")
                
                let urlString = serviceURL + "/GetProfile?AppInstallGUID=" + "\(appInstallGUID)" + "&PermitNo=\(permitNumber)&DOB=\(dob)"
                // let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
                guard let url = URL(string: urlString) else{
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
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
                            UserProfileDefaults.profileID = stringData
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
    
    func fetchDriverDetails(completion: @escaping ([[String]],Bool) -> ())  {
      
        var driverArray = [[String]]()

        if let appInstallGUID = getAppInstallGUID() {

            if(appInstallGUID != ""){
                print("\(appInstallGUID)")

//                http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=Driver&AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&ProfileId=12485&CultureId=0
                
                if let profileId = UserProfileDefaults.profileID {
                    if (profileId != "") {
                        let urlString = serviceURL + "/ReadData?RequestType=\(driver)&AppInstallGUID=\(appInstallGUID)&ProfileId=\(profileId)&CultureId=\(cultureIdEN)"
                        // let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
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
                                    completion(driverArray, false)
                                }
                                return
                            }
                            let driverProfile = DriverProfile()
                            var permitDetails = [String]()
                            var driverDetails = [String]()
                            var FranchiseDetails = [String]()

                            do
                            {
                                guard let receivedData = data,  let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [[String: AnyObject]] else{
                                    DispatchQueue.main.async {
                                        completion(driverArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                   
//                                    if let PERMIT_NUMBER = dict["PERMIT_NUMBER"] as? Int, let CERT_DRIVER_ID = dict["CERT_DRIVER_ID"] as? Int, let PERMIT_ISSUE_DATE = dict["PERMIT_ISSUE_DATE"]as? Date, let PERMIT_LAST_RENEW_DATE = dict["PERMIT_LAST_RENEW_DATE"] as? Date, let PERMIT_EXPIRY_DATE = dict["PERMIT_EXPIRY_DATE"] as? Date, let DRIVER_NAME_EN = dict["DRIVER_NAME_EN"] as? String, let DRIVER_NAME_AR = dict["DRIVER_NAME_AR"] as? String, let MOBILE_NO = dict["MOBILE_NO"]as? String, let LICENSE_SOURCE_ID = dict["LICENSE_SOURCE_ID"] as? Int, let LICENSE_NO = dict["LICENSE_NO"] as? String, let LICENSE_EXP_DATE = dict["LICENSE_EXP_DATE"] as? String, let TCF_NUMBER = dict["TCF_NUMBER"] as? String, let PROFILE_STATUS = dict["PROFILE_STATUS"] as? String, let DRIVER_STATUS_EN = dict["DRIVER_STATUS_EN"] as? String, let DRIVER_STATUS_AR = dict["DRIVER_STATUS_AR"] as? String, let PERMIT_STATUS_EN = dict["PERMIT_STATUS_EN"] as? String, let PERMIT_STATUS_AR = dict["PERMIT_STATUS_AR"] as? String, let FRANCHISE_ID = dict["FRANCHISE_ID"] as? Int, let FRANCHISE_NAME_EN = dict["FRANCHISE_NAME_EN"] as? String, let FRANCHISE_NAME_AR = dict["FRANCHISE_NAME_AR"] as? String, let FRANCHISE_TYPE_EN = dict["FRANCHISE_TYPE_EN"] as? String, let FRANCHISE_TYPE_AR = dict["FRANCHISE_TYPE_AR"] as? String, let PROFILE_CREATED_DATE = dict["PROFILE_CREATED_DATE"] as? Date, let PROFILE_MODIFY_DATE = dict["PROFILE_MODIFY_DATE"] as? Date,let EMIRATES_ID_NO = dict["EMIRATES_ID_NO"] as? String, let EMIRATES_ID_EXP_DATE = dict["EMIRATES_ID_EXP_DATE"] as? Date, let OPERATING_REGION_EN = dict["OPERATING_REGION_EN"] as? String, let OPERATING_REGION_AR = dict["OPERATING_REGION_AR"] as? String, let NATIONALITY_EN = dict["NATIONALITY_EN"] as? String, let NATIONALITY_AR = dict["NATIONALITY_AR"] as? String, let GENDER_EN = dict["GENDER_EN"] as? String, let GENDER_AR = dict["GENDER_AR"] as? String, let RELIGION_EN = dict["RELIGION_EN"] as? String, let RELIGION_AR = dict["RELIGION_AR"] as? String, let DOB = dict["DOB"] as? Date {
//                                 }
                                    if let PERMIT_NUMBER = dict["PERMIT_NUMBER"] as? Int{
                                        driverProfile.PERMIT_NUMBER = PERMIT_NUMBER
                                        permitDetails.append(String(PERMIT_NUMBER))
                                    }
                                    else{
                                        driverProfile.PERMIT_NUMBER = nil
                                        permitDetails.append("")
                                    }
                                    if let PERMIT_ISSUE_DATE = dict["PERMIT_ISSUE_DATE"] as? String{
                                        driverProfile.PERMIT_ISSUE_DATE = PERMIT_ISSUE_DATE
                                        let a = Helper.getCorrectDate(dateString: PERMIT_ISSUE_DATE)
                                        permitDetails.append(a)
                                    }
                                    else{
                                        driverProfile.PERMIT_ISSUE_DATE = nil
                                        permitDetails.append("")
                                    }
                                    if let PERMIT_LAST_RENEW_DATE = dict["PERMIT_LAST_RENEW_DATE"] as? String{
                                        driverProfile.PERMIT_LAST_RENEW_DATE = PERMIT_LAST_RENEW_DATE
                                        let a = Helper.getCorrectDate(dateString: PERMIT_LAST_RENEW_DATE)
                                        permitDetails.append(a)
                                    }
                                    else{
                                        driverProfile.PERMIT_LAST_RENEW_DATE = nil
                                        permitDetails.append("")
                                    }
                                    if let PERMIT_EXPIRY_DATE = dict["PERMIT_EXPIRY_DATE"] as? String{
                                        driverProfile.PERMIT_EXPIRY_DATE = PERMIT_EXPIRY_DATE
                                        let a = Helper.getCorrectDate(dateString: PERMIT_EXPIRY_DATE)
                                        permitDetails.append(a)
                                    }
                                    else{
                                        driverProfile.PERMIT_EXPIRY_DATE = nil
                                        permitDetails.append("")
                                    }
                                    if let PERMIT_STATUS_EN = dict["PERMIT_STATUS_EN"] as? String{
                                        driverProfile.PERMIT_STATUS_EN = PERMIT_STATUS_EN
                                        permitDetails.append(PERMIT_STATUS_EN)
                                    }
                                    else{
                                        driverProfile.PERMIT_STATUS_EN = nil
                                        permitDetails.append("")
                                    }
                                    
                                    
                                    
                                    if let DRIVER_NAME_EN = dict["DRIVER_NAME_EN"] as? String{
                                        driverProfile.DRIVER_NAME_EN = DRIVER_NAME_EN
                                        driverDetails.append(DRIVER_NAME_EN)
                                    }
                                    else{
                                        driverProfile.DRIVER_NAME_EN = nil
                                        driverDetails.append("")
                                    }
                                    if let LICENSE_NO = dict["LICENSE_NO"] as? String{
                                        driverProfile.LICENSE_NO = LICENSE_NO
                                        driverDetails.append(LICENSE_NO)
                                    }
                                    else{
                                        driverProfile.LICENSE_NO = nil
                                        driverDetails.append("")
                                    }
                                    if let LICENSE_SOURCE_ID = dict["LICENSE_SOURCE_ID"] as? Int{
                                        driverProfile.LICENSE_SOURCE_ID = LICENSE_SOURCE_ID
                                        driverDetails.append(String(LICENSE_SOURCE_ID))
                                    }
                                    else{
                                        driverProfile.LICENSE_SOURCE_ID = nil
                                        driverDetails.append("")
                                    }
                                    if let LICENSE_EXP_DATE = dict["LICENSE_EXP_DATE"] as? String{
                                        driverProfile.LICENSE_EXP_DATE = LICENSE_EXP_DATE
                                        let a = Helper.getCorrectDate(dateString: LICENSE_EXP_DATE)
                                        driverDetails.append(a)
                                    }
                                    else{
                                        driverProfile.LICENSE_EXP_DATE = nil
                                        driverDetails.append("")
                                    }
                                    if let PROFILE_STATUS = dict["PROFILE_STATUS"] as? String{
                                        driverProfile.PROFILE_STATUS = PROFILE_STATUS
                                        driverDetails.append(PROFILE_STATUS)
                                    }
                                    else{
                                        driverProfile.PROFILE_STATUS = nil
                                        driverDetails.append("")
                                    }
                                    if let DRIVER_STATUS_EN = dict["DRIVER_STATUS_EN"] as? String{
                                        driverProfile.DRIVER_STATUS_EN = DRIVER_STATUS_EN
                                        driverDetails.append(DRIVER_STATUS_EN)
                                    }
                                    else{
                                        driverProfile.DRIVER_STATUS_EN = nil
                                        driverDetails.append("")
                                    }
                                    if let EMIRATES_ID_NO = dict["EMIRATES_ID_NO"] as? String{
                                        driverProfile.EMIRATES_ID_NO = EMIRATES_ID_NO
                                    }
                                    else{
                                        driverProfile.EMIRATES_ID_NO = nil
                                    }
                                    if let GENDER_EN = dict["GENDER_EN"] as? String{
                                        driverProfile.GENDER_EN = GENDER_EN
                                    }
                                    else{
                                        driverProfile.GENDER_EN = nil
                                    }
                                    if let NATIONALITY_EN = dict["NATIONALITY_EN"] as? String{
                                        driverProfile.NATIONALITY_EN = NATIONALITY_EN
                                        UserProfileDefaults.nationalityEn = NATIONALITY_EN
                                    }
                                    else{
                                        driverProfile.NATIONALITY_EN = nil
                                    }
                                    if let RELIGION_EN = dict["RELIGION_EN"] as? String{
                                        driverProfile.RELIGION_EN = RELIGION_EN
                                    }
                                    else{
                                        driverProfile.RELIGION_EN = nil
                                    }
                                    if let DOB = dict["DOB"] as? String{
                                        driverProfile.DOB = DOB
                                       let a = Helper.getCorrectDate(dateString: DOB)
                                        driverDetails.append(a)
                                    }
                                    else{
                                        driverProfile.DOB = nil
                                        driverDetails.append("")
                                    }
                                    if let MOBILE_NO = dict["MOBILE_NO"] as? String{
                                        driverProfile.MOBILE_NO = MOBILE_NO
                                        UserProfileDefaults.mobileNumber = MOBILE_NO
                                    }
                                    else{
                                        driverProfile.MOBILE_NO = nil
                                        UserProfileDefaults.mobileNumber = ""
                                    }
                                    if let driverPhoto = dict["DRIVER_PHOTO"] as? String{
                                        driverProfile.DRIVER_PHOTO = driverPhoto
                                        UserProfileDefaults.driverPhoto = driverPhoto
                                    }
                                    else{
                                        
                                       
                                    }
                                    if let OPERATING_REGION_EN = dict["OPERATING_REGION_EN"] as? String{
                                        driverProfile.OPERATING_REGION_EN = OPERATING_REGION_EN
                                        UserProfileDefaults.operatigRegionEn = OPERATING_REGION_EN
                                    }
                                    
                                    if let CERT_DRIVER_ID = dict["CERT_DRIVER_ID"] as? Int{
                                        driverProfile.CERT_DRIVER_ID = CERT_DRIVER_ID
                                        UserProfileDefaults.certId = "\(CERT_DRIVER_ID)"
                                    }
                                    
                                    
                                    if let FRANCHISE_NAME_EN = dict["FRANCHISE_NAME_EN"] as? String{
                                        driverProfile.FRANCHISE_NAME_EN = FRANCHISE_NAME_EN
                                        FranchiseDetails.append(FRANCHISE_NAME_EN)
                                    }
                                    else{
                                        driverProfile.FRANCHISE_NAME_EN = nil
                                        FranchiseDetails.append("")
                                    }
                                    if let FRANCHISE_TYPE_EN = dict["FRANCHISE_TYPE_EN"] as? String{
                                        driverProfile.FRANCHISE_TYPE_EN = FRANCHISE_TYPE_EN
                                        FranchiseDetails.append(FRANCHISE_TYPE_EN)
                                    }
                                    else{
                                        driverProfile.FRANCHISE_TYPE_EN = nil
                                        FranchiseDetails.append("")
                                    }
                                    
                                    driverArray.append(FranchiseDetails)
                                    driverArray.append(permitDetails)
                                    driverArray.append(driverDetails)
                                
                                
                                
                                
                                
                                
        //////////////////////////////////ARABIC//////////////////////////////////////////////////////
                                
                                    let driverProfileAr = DriverProfile()
                                var permitDetailsAr = [String]()
                                var driverDetailsAr = [String]()
                                var FranchiseDetailsAr = [String]()
                                    var driverArrayAr = [[String]]()
                                
                                if let PERMIT_NUMBER = dict["PERMIT_NUMBER"] as? Int{
                                    driverProfileAr.PERMIT_NUMBER = PERMIT_NUMBER
                                    permitDetailsAr.append(String(PERMIT_NUMBER))
                                }
                                else{
                                    driverProfileAr.PERMIT_NUMBER = nil
                                    permitDetailsAr.append("")
                                }
                                if let PERMIT_ISSUE_DATE = dict["PERMIT_ISSUE_DATE"] as? String{
                                    driverProfileAr.PERMIT_ISSUE_DATE = PERMIT_ISSUE_DATE
                                    let a = Helper.getCorrectDate(dateString: PERMIT_ISSUE_DATE)
                                    permitDetailsAr.append(a)
                                }
                                else{
                                    driverProfileAr.PERMIT_ISSUE_DATE = nil
                                    permitDetailsAr.append("")
                                }
                                if let PERMIT_LAST_RENEW_DATE = dict["PERMIT_LAST_RENEW_DATE"] as? String{
                                    driverProfileAr.PERMIT_LAST_RENEW_DATE = PERMIT_LAST_RENEW_DATE
                                    let a = Helper.getCorrectDate(dateString: PERMIT_LAST_RENEW_DATE)
                                    permitDetailsAr.append(a)
                                }
                                else{
                                    driverProfileAr.PERMIT_LAST_RENEW_DATE = nil
                                    permitDetailsAr.append("")
                                }
                                if let PERMIT_EXPIRY_DATE = dict["PERMIT_EXPIRY_DATE"] as? String{
                                    driverProfileAr.PERMIT_EXPIRY_DATE = PERMIT_EXPIRY_DATE
                                    let a = Helper.getCorrectDate(dateString: PERMIT_EXPIRY_DATE)
                                    permitDetailsAr.append(a)
                                }
                                else{
                                    driverProfileAr.PERMIT_EXPIRY_DATE = nil
                                    permitDetailsAr.append("")
                                }
                                if let PERMIT_STATUS_AR = dict["PERMIT_STATUS_AR"] as? String{
                                    driverProfileAr.PERMIT_STATUS_AR = PERMIT_STATUS_AR
                                    permitDetailsAr.append(PERMIT_STATUS_AR)
                                }
                                else{
                                    driverProfileAr.PERMIT_STATUS_AR = nil
                                    permitDetailsAr.append("")
                                }
                                
                                
                                
                                if let DRIVER_NAME_AR = dict["DRIVER_NAME_AR"] as? String{
                                    driverProfileAr.DRIVER_NAME_AR = DRIVER_NAME_AR
                                    driverDetailsAr.append(DRIVER_NAME_AR)
                                }
                                else{
                                    driverProfileAr.DRIVER_NAME_AR = nil
                                    driverDetailsAr.append("")
                                }
                                if let LICENSE_NO = dict["LICENSE_NO"] as? String{
                                    driverProfileAr.LICENSE_NO = LICENSE_NO
                                    driverDetailsAr.append(LICENSE_NO)
                                }
                                else{
                                    driverProfileAr.LICENSE_NO = nil
                                    driverDetailsAr.append("")
                                }
                                if let LICENSE_SOURCE_ID = dict["LICENSE_SOURCE_ID"] as? Int{
                                    driverProfileAr.LICENSE_SOURCE_ID = LICENSE_SOURCE_ID
                                    driverDetailsAr.append(String(LICENSE_SOURCE_ID))
                                }
                                else{
                                    driverProfileAr.LICENSE_SOURCE_ID = nil
                                    driverDetailsAr.append("")
                                }
                                if let LICENSE_EXP_DATE = dict["LICENSE_EXP_DATE"] as? String{
                                    driverProfileAr.LICENSE_EXP_DATE = LICENSE_EXP_DATE
                                    let a = Helper.getCorrectDate(dateString: LICENSE_EXP_DATE)
                                    driverDetailsAr.append(a)
                                }
                                else{
                                    driverProfileAr.LICENSE_EXP_DATE = nil
                                    driverDetailsAr.append("")
                                }
                                if let PROFILE_STATUS = dict["PROFILE_STATUS"] as? String{
                                    driverProfileAr.PROFILE_STATUS = PROFILE_STATUS
                                    driverDetailsAr.append(PROFILE_STATUS)
                                }
                                else{
                                    driverProfileAr.PROFILE_STATUS = nil
                                    driverDetailsAr.append("")
                                }
                                if let DRIVER_STATUS_EN = dict["DRIVER_STATUS_EN"] as? String{
                                    driverProfileAr.DRIVER_STATUS_EN = DRIVER_STATUS_EN
                                    driverDetailsAr.append(DRIVER_STATUS_EN)
                                }
                                else{
                                    driverProfileAr.DRIVER_STATUS_EN = nil
                                    driverDetailsAr.append("")
                                }
                                if let EMIRATES_ID_NO = dict["EMIRATES_ID_NO"] as? String{
                                    driverProfileAr.EMIRATES_ID_NO = EMIRATES_ID_NO
                                }
                                else{
                                    driverProfileAr.EMIRATES_ID_NO = nil
                                }
                                if let GENDER_AR = dict["GENDER_AR"] as? String{
                                    driverProfileAr.GENDER_AR = GENDER_AR
                                }
                                else{
                                    driverProfileAr.GENDER_AR = nil
                                }
                                if let NATIONALITY_AR = dict["NATIONALITY_AR"] as? String{
                                    driverProfileAr.NATIONALITY_AR = NATIONALITY_AR
                                     UserProfileDefaults.nationalityAr = NATIONALITY_AR
                                }
                                else{
                                    driverProfileAr.NATIONALITY_AR = nil
                                }
                                if let RELIGION_AR = dict["RELIGION_AR"] as? String{
                                    driverProfileAr.RELIGION_AR = RELIGION_AR
                                   
                                }
                                else{
                                    driverProfileAr.RELIGION_AR = nil
                                }
                                if let DOB = dict["DOB"] as? String{
                                    driverProfileAr.DOB = DOB
                                    let a = Helper.getCorrectDate(dateString: DOB)
                                    driverDetailsAr.append(a)
                                }
                                else{
                                    driverProfileAr.DOB = nil
                                    driverDetailsAr.append("")
                                }
                                if let MOBILE_NO = dict["MOBILE_NO"] as? String{
                                    driverProfileAr.MOBILE_NO = MOBILE_NO
                                    UserProfileDefaults.mobileNumber = MOBILE_NO
                                }
                                else{
                                    driverProfileAr.MOBILE_NO = nil
                                    UserProfileDefaults.mobileNumber = ""
                                }
                                if let driverPhoto = dict["DRIVER_PHOTO"] as? String{
                                    driverProfileAr.DRIVER_PHOTO = driverPhoto
                                    UserProfileDefaults.driverPhoto = driverPhoto
                                }
                                else{
                                    
                                    
                                }
                                
                                    if let OPERATING_REGION_AR = dict["OPERATING_REGION_AR"] as? String{
                                        driverProfile.OPERATING_REGION_AR = OPERATING_REGION_AR
                                        UserProfileDefaults.operatigRegionAr = OPERATING_REGION_AR
                                    }
                                    
                                    
                                
                                
                                if let FRANCHISE_NAME_AR = dict["FRANCHISE_NAME_AR"] as? String{
                                    driverProfile.FRANCHISE_NAME_AR = FRANCHISE_NAME_AR
                                    FranchiseDetailsAr.append(FRANCHISE_NAME_AR)
                                }
                                else{
                                    driverProfile.FRANCHISE_NAME_AR = nil
                                    FranchiseDetailsAr.append("")
                                }
                                if let FRANCHISE_TYPE_AR = dict["FRANCHISE_TYPE_AR"] as? String{
                                    driverProfile.FRANCHISE_TYPE_AR = FRANCHISE_TYPE_AR
                                    FranchiseDetailsAr.append(FRANCHISE_TYPE_AR)
                                }
                                else{
                                    driverProfile.FRANCHISE_TYPE_EN = nil
                                    FranchiseDetailsAr.append("")
                                }
                                
                                driverArrayAr.append(FranchiseDetailsAr)
                                driverArrayAr.append(permitDetailsAr)
                                driverArrayAr.append(driverDetailsAr)


                                DriverDetailsUserDefault.driverDetails = driverArrayAr
        ////////////////////////////////////////////ARABIC////////////////////////////////////////////////
                            
                                }
                                
                                
                           
                                
                                //Checking for response code whether the response is success or not
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(driverArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(driverArray, false)
                                    }
                                }
                            }
                            catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(driverArray, false)
                                }
                            }
                            }.resume()
                    }else{
                        DispatchQueue.main.async {
                            completion(driverArray, false)
                        }
                    }
               
            }else{
                    DispatchQueue.main.async {
                        completion(driverArray, false)
                    }
            }
        }
        else{
                DispatchQueue.main.async {
                    completion(driverArray, false)
                }
        }

     }
    }

    func changeMobileNumber(mobileNumber: String , completion: @escaping (Bool, String)->()){
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                print("\(appInstallGUID)")
                
//                http://83.111.121.89:338/LESMOBILEAPI/Masters/UpdateMobileNo?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&ProfileId=12485&MobileNo=1234567890
                if let profileId = UserProfileDefaults.profileID {
                    let urlString = serviceURL + "/UpdateMobileNo?AppInstallGUID=\(appInstallGUID)&ProfileId=\(profileId)&MobileNo=\(mobileNumber)"
                    guard let url = URL(string: urlString) else{
                        DispatchQueue.main.async {
                            completion(false,"")
                        }
                        return
                    }
                    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                    request.httpMethod = "POST"
                    
                    request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField:"Accept")
                    
                    let urlSessionConfiguration = URLSessionConfiguration.default
                    let urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
                    
                    urlSession.dataTask(with: request) { (data, response, error) in
                        
                        if error != nil{
                            print(error ?? "Error")
                            DispatchQueue.main.async {
                                completion(false, "Request can not be processed")
                            }
                            return
                        }
                        
                        do
                        {
                            guard let receivedData = data,  let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [String: AnyObject] else{
                                DispatchQueue.main.async {
                                    completion(false, "Request can not be processed")
                                }
                                return
                            }
                            //Checking for response code whether the response is success or not
                            if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                            {
                                DispatchQueue.main.async {
                                    completion(true, "Update request sent")
                                }
                            }
                            else //returning
                            {
                                DispatchQueue.main.async {
                                    completion(false, "Bad Request")
                                }
                            }
                        }
                        catch let receivedError as NSError
                        {
                            DispatchQueue.main.async {
                                completion(false, "Request can not be processed")
                            }
                            print(receivedError.localizedDescription)
                        }
                        }.resume()
                }else{
                    DispatchQueue.main.async {
                        completion(false, "Profile Id doesn't match")
                    }
                }
                    
                }
                else{
                DispatchQueue.main.async {
                    completion(false, "App Install GUID is empty")
                }
                }
        }
        else{
            DispatchQueue.main.async {
                completion(false, "App Install Guid is null")
            }
        }
        
    }
    
    func fetchDriverFines(fDate: String, toDate: String, completion: @escaping ([DriverFine],Bool)->()){
        
        var driverFinesArray = [DriverFine]()

        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
//                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=DriverFines&ProfileID=25176&CultureId=0
                        let urlString = serviceURL + "/ReadData?AppInstallGUID=\(appInstallGUID)&RequestType=\(driverFines)&ProfileID=\(profileId)&CultureId=\(cultureIdEN)&FromDate=\(fDate)&ToDate=\(toDate)"
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
                                    completion(driverFinesArray, false)
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
                                        completion(driverFinesArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let fine = DriverFine()
                                    fine.FINE_SOURCE = dict["FINE_SOURCE"] as? Int
                                    fine.TRANS_ID = dict["TRANS_ID"] as? Int
                                    fine.FINE_ID = dict["FINE_ID"] as? Int
                                    fine.FINE_NO = dict["FINE_NO"] as? String
                                    fine.VIOLATION_ID = dict["VIOLATION_ID"] as? Int
                                    fine.ARTICLE_CODE = dict["ARTICLE_CODE"] as? String
                                    fine.ARTICLE_NAME  = dict["ARTICLE_NAME"] as? String
                                    fine.ARTICLE_NAME_AR = dict["ARTICLE_NAME_AR"] as? String
                                    fine.STATUS_NAME = dict["STATUS_NAME"] as? String
                                    fine.STATUS_NAME_AR = dict["STATUS_NAME_AR"] as? String
                                    fine.FINE_DATE = dict["FINE_DATE"] as? String
                                    fine.LOCATION_NAME = dict["LOCATION_NAME"] as? String
                                    fine.DRIVER_BLACK_POINTS = dict["DRIVER_BLACK_POINTS"] as? CGFloat
                                    fine.DRIVER_FINE_AMOUNT = dict["DRIVER_FINE_AMOUNT"] as? CGFloat
                                    fine.COMPANY_BLACK_POINTS = dict["COMPANY_BLACK_POINTS"] as? CGFloat
                                    fine.COMPANY_FINE_AMOUNT = dict["COMPANY_FINE_AMOUNT"] as? CGFloat
                                    fine.IS_VALID = dict["IS_VALID"] as? Int
                                    fine.IS_POSSIBLE_FOR_GREVIENCE = dict["IS_POSSIBLE_FOR_GREVIENCE"] as? Int
                                    fine.GPS_COORDINATES = dict["GPS_COORDINATES"] as? String
                                    fine.REV_REQ_FROM_MOBILE = dict["REV_REQ_FROM_MOBILE"] as? String
                                    fine.IS_INVESTIGATION = dict["IS_INVESTIGATION"] as? Int
                                    driverFinesArray.append(fine)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(driverFinesArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(driverFinesArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(driverFinesArray, false)
                                }
                            }
                            
                        }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(driverFinesArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(driverFinesArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(driverFinesArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(driverFinesArray, false)
            }
        }
      
    }
    
    
    func fetchWhitepoints(completion: @escaping ([WhitePoint],Bool)->()){
        
        fetchDataBasedOnRequestType(requestType: getWhitePoint) { (recievedArray,isCompleted) in
            var whitePointArray = [WhitePoint]()

            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let whitePoint = WhitePoint()
                        if let d = dict as? [String:AnyObject]{
                            whitePoint.WHITE_POINTS = d["WHITE_POINTS"] as? Int
                            whitePointArray.append(whitePoint)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(whitePointArray, true)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(whitePointArray, false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(whitePointArray, false)
                }
            }
           
        }
    }
    
    func fetchBlackpoints(completion: @escaping ([BlackPoint],Bool)->()){
        
        fetchDataBasedOnRequestType(requestType: getBlackPoint) { (recievedArray,isCompleted) in
            var blackPointArray = [BlackPoint]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let blackPoint = BlackPoint()
                        if let d = dict as? [String:AnyObject]{
                            blackPoint.BLACK_POINTS = d["BLACK_POINTS"] as? Int
                            blackPoint.MAX_BLACK_POINTS = d["MAX_BLACK_POINTS"] as? Int
                            blackPointArray.append(blackPoint)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(blackPointArray, true)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        completion(blackPointArray, false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(blackPointArray, false)
                }
            }

           
        }
    }
    
    func fetchPermitDetails(completion: @escaping ([Permit], Bool)->()){
        
        fetchDataBasedOnRequestType(requestType: checkPermitStatus) { (recievedArray,isCompleted)  in
            var permitArray = [Permit]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let permit = Permit()
                        if let d = dict as? [String:AnyObject] {
                            
                            permit.PERMIT_STATUS_ID = d["PERMIT_STATUS_ID"] as? Int
                            permit.PERMIT_STATUS_EN = d["PERMIT_STATUS_EN"] as? String
                            permit.PERMIT_STATUS_AR = d["PERMIT_STATUS_AR"] as? String
                            permit.PERMIT_LAST_RENEW_DATE = d["PERMIT_LAST_RENEW_DATE"] as? String
                            permit.PERMIT_ISSUE_DATE = d["PERMIT_ISSUE_DATE"] as? String
                            permit.PERMIT_EXPIRY_DATE = d["PERMIT_EXPIRY_DATE"] as? String
                            permitArray.append(permit)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(permitArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(permitArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(permitArray,false)
                }
            }
        }
    }
    
    
    func fetchPermitRenewalHistory(completion: @escaping ([PermitRenewalHistory], Bool)->()){
        
        fetchDataBasedOnRequestType(requestType: permitRenewHistory) { (recievedArray,isCompleted)  in
            var renewalHistoryArray = [PermitRenewalHistory]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let history = PermitRenewalHistory()
                        if let d = dict as? [String:AnyObject] {
                            
                        
                            history.PERMIT_RENEW_DATE = d["PERMIT_RENEW_DATE"] as? String
                            history.PERMIT_ISSUE_DATE = d["PERMIT_ISSUE_DATE"] as? String
                            history.PERMIT_EXPIRY_DATE = d["PERMIT_EXPIRY_DATE"] as? String
                            renewalHistoryArray.append(history)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(renewalHistoryArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(renewalHistoryArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(renewalHistoryArray,false)
                }
            }
        }
    }
    
    
    func fetchPermitSuspensionHistory(completion: @escaping ([PermitSuspensionHistory], Bool)->()){
        
        fetchDataBasedOnRequestType(requestType: driverSuspension) { (recievedArray,isCompleted)  in
            var suspensionHistoryArray = [PermitSuspensionHistory]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let history = PermitSuspensionHistory()
                        if let d = dict as? [String:AnyObject] {
                            
                            history.SUSPENSION_TYPE = d["SUSPENSION_TYPE"] as? String
                            history.SUSPENSION_FROM = d["SUSPENSION_FROM"] as? String
                            history.SUSPENSION_UNTIL = d["SUSPENSION_UNTIL"] as? String
                            history.SUSPENSION_DAYS = d["SUSPENSION_DAYS"] as? Int
                            history.IS_CLOSED_ = d["IS_CLOSED_"] as? Int
                            history.COMPLETED = d["COMPLETED"] as? String
                            history.SUSPENSION_REASON = d["SUSPENSION_REASON"] as? String
                            history.SUSPENSION_DOCUMENT = d["SUSPENSION_DOCUMENT"] as? String
                            suspensionHistoryArray.append(history)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(suspensionHistoryArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(suspensionHistoryArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(suspensionHistoryArray,false)
                }
            }
        }
    }
    
    
    
    
    func fetchVehicleOperatingZone(completion: @escaping ([OperatingZone], Bool)->()){
        
        fetchDataBasedOnRequestType(requestType: getOperatingZone) { (recievedArray,isCompleted)  in
            var operatingZoneArray = [OperatingZone]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let operatingZone = OperatingZone()
                        if let d = dict as? [String:AnyObject] {
                            
                            operatingZone.VEHICLE_ID = d["VEHICLE_ID"] as? Int
                            operatingZone.TAXI_NUMBER = d["TAXI_NUMBER"] as? Int
                            operatingZone.REGION_ID = d["REGION_ID"] as? Int
                            operatingZone.REGION_NAME_EN = d["REGION_NAME_EN"] as? String
                            operatingZone.REGION_NAME_AR = d["REGION_NAME_AR"] as? String
                            operatingZoneArray.append(operatingZone)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(operatingZoneArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(operatingZoneArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(operatingZoneArray,false)
                }
            }
        }
    }
    
    func checkVehicleQualityInspectionTime(completion: @escaping ([Inspection], Bool)->()){
        
        fetchDataBasedOnRequestType(requestType: checkOPQTime) { (recievedArray,isCompleted)  in
            var inspectionArray = [Inspection]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let inspection = Inspection()
                        if let d = dict as? [String:AnyObject] {
                            
                            inspection.VEHICLE_ID = d["VEHICLE_ID"] as? Int
                            inspection.TAXI_NUMBER = d["TAXI_NUMBER"] as? Int
                            inspection.PROFILE_ID = d["REGION_ID"] as? Int
                            inspection.VEH_INSPECTION_TIME = d["VEH_INSPECTION_TIME"] as? String
                            inspection.DRV_INSPECTION_TIME = d["DRV_INSPECTION_TIME"] as? String
                            inspectionArray.append(inspection)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(inspectionArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(inspectionArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(inspectionArray,false)
                }
            }
        }
    }
    
    func fetchVehicleStatus(completion: @escaping ([VehicleStatus], Bool)->()){

        
        //        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&ProfileID=19358&RequestType=GetVehicleStatus
       
        fetchDataBasedOnRequestType(requestType: getVehicleStatus) { (recievedArray,isCompleted)  in
            var vehicleStatusArray = [VehicleStatus]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let vehicleStatus = VehicleStatus()
                        if let d = dict as? [String:AnyObject] {
                            
                            vehicleStatus.VEHICLE_ID = d["VEHICLE_ID"] as? Int
                            vehicleStatus.TAXI_NUMBER = d["TAXI_NUMBER"] as? Int
                            vehicleStatus.OPERATING_REGION = d["OPERATING_REGION"] as? String
                            vehicleStatus.STICKER_NO = d["STICKER_NO"] as? String
                            vehicleStatus.EXPIRY_DATE = d["EXPIRY_DATE"] as? String
                            vehicleStatus.MAKE = d["MAKE"] as? String
                            vehicleStatus.MODEL = d["MODEL"] as? String
                            vehicleStatus.CHASSIS_NO = d["CHASSIS_NO"] as? String
                            vehicleStatus.FUEL_TYPE = d["FUEL_TYPE"] as? String
                            vehicleStatus.VEHICLE_SHIFT = d["VEHICLE_SHIFT"] as? String
                            vehicleStatus.SEAT_COUNT = d["SEAT_COUNT"] as? Int
                            vehicleStatus.ENGINE_NO = d["ENGINE_NO"] as? String
                            vehicleStatus.VEHICLE_STATUS = d["VEHICLE_STATUS"] as? String
                            vehicleStatus.ADDITIONAL_REGION = d["ADDITIONAL_REGION"] as? String

                            
                            vehicleStatusArray.append(vehicleStatus)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(vehicleStatusArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(vehicleStatusArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(vehicleStatusArray,false)
                }
            }
        }
    }
    
    
    
    func checkVehicleRenewHistoryFromService(completion: @escaping ([VehicleRenewalHistory], Bool)->()){
        
//http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=GetVehRenHistory&ProfileID=28648
        
        fetchDataBasedOnRequestType(requestType: getVehRenHistory) { (recievedArray,isCompleted)  in
            var vehicleRenewHistoryArray = [VehicleRenewalHistory]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let renewHistory = VehicleRenewalHistory()
                        if let d = dict as? [String:AnyObject] {
                            
                            renewHistory.RENEW_DATE = d["RENEW_DATE"] as? String
                            renewHistory.EXIPRY_DATE = d["EXIPRY_DATE"] as? String
                            renewHistory.STICKER_NO = d["STICKER_NO"] as? String
                            renewHistory.TAXI_NUMBER = d["TAXI_NUMBER"] as? Int
                         
                            
                            
                            vehicleRenewHistoryArray.append(renewHistory)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(vehicleRenewHistoryArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(vehicleRenewHistoryArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(vehicleRenewHistoryArray,false)
                }
            }
        }
    }
    
    func fetchFeedbackQuestions(completion: @escaping ([FeedbackQuestion], Bool)->()){
        
        //http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=632B06AA-FD07-4BB6-8BC6-02D4A7106FE5&RequestType=FeedbackQuestion&CultureId=0
        
        fetchDataBasedOnRequestType(requestType: feedbackQuestion) { (recievedArray,isCompleted)  in
            var feedbackQuestionsArray = [FeedbackQuestion]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let obj = FeedbackQuestion()
                        if let d = dict as? [String:AnyObject] {
                            
                            obj.Question = d["Question"] as? String
                            obj.QuestionID = d["QuestionID"] as? Int
                            obj.QuestionType = d["QuestionType"] as? String
                            
                            feedbackQuestionsArray.append(obj)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(feedbackQuestionsArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(feedbackQuestionsArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(feedbackQuestionsArray,false)
                }
            }
        }
    }
    
    func fetchFeedbackOptions(completion: @escaping ([FeedbackOptions], Bool)->()){
        
        //http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=632B06AA-FD07-4BB6-8BC6-02D4A7106FE5&RequestType=FeedbackQstOpt&CultureId=0
        
        fetchDataBasedOnRequestType(requestType: feedbackQstOpt) { (recievedArray,isCompleted)  in
            var feedbackOptionsArray = [FeedbackOptions]()
            if(isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let obj = FeedbackOptions()
                        if let d = dict as? [String:AnyObject] {
                            
                            obj.OptionID = d["OptionID"] as? Int
                            obj.QuestionID = d["QuestionID"] as? Int
                            obj.OptionText = d["OptionText"] as? String
                            
                            feedbackOptionsArray.append(obj)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(feedbackOptionsArray,true)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        completion(feedbackOptionsArray,false)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(feedbackOptionsArray,false)
                }
            }
        }
    }
    
    
    
    
  func fetchDataBasedOnRequestType(requestType: String , completion: @escaping ([AnyObject]?, Bool)->()){
    
    var recievedArray = [AnyObject]()

        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        //                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=DriverFines&ProfileID=25176&CultureId=0
                        
//                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=CheckOPQTime&AppInstallGUID=1337535510Nff985c535bce3d1a964e95&ProfileID=19384
                        
//                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=ListforInvestBooking&ProfileID=7060&CultureId=0
                        
                        
                        var urlString = ""
                        if(requestType == getOperatingZone || requestType == checkOPQTime){
                            
                            urlString = serviceURL + "/ReadData?RequestType=\(requestType)&AppInstallGUID=\(appInstallGUID)&ProfileID=\(profileId)"
                            
                        }
                        else if (requestType == getVehicleStatus){
                            urlString = serviceURL + "/ReadData?AppInstallGUID=\(appInstallGUID)&ProfileID=\(profileId)&RequestType=\(requestType)"
                        }
                        else if (requestType == feedbackQuestion || requestType == feedbackQstOpt){
//                            http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=632B06AA-FD07-4BB6-8BC6-02D4A7106FE5&RequestType=FeedbackQuestion&CultureId=0
                            urlString = serviceURL + "/ReadData?&AppInstallGUID=\(appInstallGUID)&RequestType=\(requestType)&CultureId=\(cultureIdEN)"
                            
                        }
                        
//                        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&RequestType=GetVehRenHistory&ProfileID=28648
                        else{
                            urlString = serviceURL + "/ReadData?RequestType=\(requestType)&AppInstallGUID=\(appInstallGUID)&ProfileID=\(profileId)"
                        }
                     
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
    
    func fetchExamCenterLookup(completion: @escaping ([ExamCenterLookUp], Bool)->()){
        
        fetchLookUps(requestType: examCenterLookup) { (recievedArray,isCompleted)  in
            
            var examCenterArray = [ExamCenterLookUp]()
            if (isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let examcenter = ExamCenterLookUp()
                        if let d = dict as? [String:AnyObject]{
                            examcenter.ID = d["ID"] as? Int
                            examcenter.NAME_AR = d["NAME_AR"] as? String
                            examcenter.NAME_EN = d["NAME_EN"] as? String
                            examCenterArray.append(examcenter)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(examCenterArray, true)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(examCenterArray, false)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    completion(examCenterArray, false)
                }
            }
           
        }
   }
    
    
    
    func grievanceLookup(completion: @escaping ([GrievanceLookUp], Bool)->()){
        
        fetchLookUps(requestType: violReversalTypeLookup) { (recievedArray,isCompleted)  in
            
            var grievanceArray = [GrievanceLookUp]()
            if (isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let grievanceObj = GrievanceLookUp()
                        if let d = dict as? [String:AnyObject]{
                            grievanceObj.ID = d["ID"] as? Int
                            grievanceObj.NAME_AR = d["NAME_AR"] as? String
                            grievanceObj.NAME_EN = d["NAME_EN"] as? String
                            grievanceArray.append(grievanceObj)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(grievanceArray, true)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(grievanceArray, false)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    completion(grievanceArray, false)
                }
            }
            
        }
    }
    
    
    
    
    
    func fetchServiceLookup(completion: @escaping ([ServiceLookup],Bool)->()){
        
        fetchLookUps(requestType: serviceLookup) { (recievedArray,isCompleted)  in
            var serviceArray = [ServiceLookup]()
            if (isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let lookUp = ServiceLookup()
                            lookUp.ID = dict["ID"] as? Int
                            lookUp.NAME_AR = dict["NAME_AR"] as? String
                            lookUp.NAME_EN = dict["NAME_EN"] as? String
                            serviceArray.append(lookUp)
                        }
                    
                    DispatchQueue.main.async {
                        completion(serviceArray, true)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(serviceArray, false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(serviceArray, false)
                }
            }
            
        }
   }
    
    
    func fetchInvestigationCenterLookup(completion: @escaping ([InvestigationCenter],Bool)->()){
        
        fetchLookUps(requestType: ivestigationLookup) { (recievedArray,isCompleted)  in
            var investigationCenterArray = [InvestigationCenter]()
            if (isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let lookUp = InvestigationCenter()
                        lookUp.ID = dict["ID"] as? Int
                        lookUp.NAME_AR = dict["NAME_AR"] as? String
                        lookUp.NAME_EN = dict["NAME_EN"] as? String
                        investigationCenterArray.append(lookUp)
                    }
                    
                    DispatchQueue.main.async {
                        completion(investigationCenterArray, true)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(investigationCenterArray, false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(investigationCenterArray, false)
                }
            }
            
        }
    }
    
    func fetchOperatingZoneLookup(completion: @escaping ([OperatingRegionLookup],Bool)->()){
        
        fetchLookUps(requestType: oprRegionLookup) { (recievedArray,isCompleted)  in
            var operatingRegionArray = [OperatingRegionLookup]()
            if (isCompleted){
                if let array = recievedArray {
                    for dict in array {
                        let lookUp = OperatingRegionLookup()
                        lookUp.ID = dict["ID"] as? Int
                        lookUp.NAME_AR = dict["NAME_AR"] as? String
                        lookUp.NAME_EN = dict["NAME_EN"] as? String
                        operatingRegionArray.append(lookUp)
                    }
                    
                    DispatchQueue.main.async {
                        completion(operatingRegionArray, true)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(operatingRegionArray, false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(operatingRegionArray, false)
                }
            }
            
        }
    }
    
    
    
    
    
    
    
    
    func fetchLookUps(requestType: String, completion: @escaping ([[String:AnyObject]]?, Bool)->()){
        
        var recievedArray = [[String:AnyObject]]()
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                      // http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=ExamCenterLookup&AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45
                        
                        let urlString = serviceURL + "/ReadData?RequestType=\(requestType)&AppInstallGUID=\(appInstallGUID)"
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
                                    print("Contains String Data")
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(recievedArray, false)
                                    }
                                    return
                                }
                                
                                recievedArray = json
                                
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
    
    func isEligibleForBookingExam(serviceType: String , completion: @escaping ([Level],Bool)->()){
        
//        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=CheckExamStatus&AppInstallGUID=94D6CA2E-A74A-4187-95CB-86108531295B&ProfileID=19358&ServiceType=31104
        var levelArray = [Level]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){

                        let urlString = serviceURL + "/ReadData?RequestType=\(checkExamStatus)&AppInstallGUID=\(appInstallGUID)&ProfileID=\(profileId)&ServiceType=\(serviceType)"
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
                                    completion(levelArray, false)
                                }
                                return
                            }
                            do {
                                guard let recievedData = data else {
                                    DispatchQueue.main.async {
                                        completion(levelArray, false)
                                    }
                                    return
                                }
                                if let stringData = String(data: recievedData, encoding: String.Encoding.utf8)  {
                                    print("Contains String Data")
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(levelArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let level = Level()
                                    level.LEVEL_DESCRION_EN = dict["LEVEL_DESCRION_EN"] as? String
                                    level.LEVEL_DESCRION_AR = dict["LEVEL_DESCRION_AR"] as? String
                                    level.QUESTIONAIRE_ID = dict["QUESTIONAIRE_ID"] as? Int
                                
                                    levelArray.append(level)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(levelArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(levelArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(levelArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(levelArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(levelArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(levelArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(levelArray, false)
            }
        }
    }
  
  
    
    func fetchExamResult(fDate: String, toDate: String, completion: @escaping ([ExamResult],Bool)-> ()){
//        http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=ExamResult&AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&ProfileID=21024&CultureId=0&FromDate=2017-02-02&ToDate=2017-10-02
        var examResultArray = [ExamResult]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        let urlString = serviceURL + "/ReadData?AppInstallGUID=\(appInstallGUID)&ProfileID=\(profileId)&CultureId=\(cultureIdEN)&FromDate=\(fDate)&ToDate=\(toDate)&RequestType=\(examResult)"
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
                                    completion(examResultArray, false)
                                }
                                return
                            }
                            do {
                                guard let recievedData = data else {
                                    DispatchQueue.main.async {
                                        completion(examResultArray, false)
                                    }
                                    return
                                }
                                if let stringData = String(data: recievedData, encoding: String.Encoding.utf8)  {
                                    print("Contains String Data")
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(examResultArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let examResult = ExamResult()
                                    examResult.TRANS_NO = dict["TRANS_NO"] as? String
                                    examResult.ASSESSMENT_CENTER = dict["ASSESSMENT_CENTER"] as? String
                                    examResult.IS_PASSED = dict["IS_PASSED"] as? Int
                                    examResult.LEVEL_DESCRION_EN = dict["LEVEL_DESCRION_EN"] as? String
                                    examResult.LEVEL_DESCRION_AR = dict["LEVEL_DESCRION_AR"] as? String
                                    examResult.ASSESSMENT_MARK = dict["ASSESSMENT_MARK"] as? Double
                                    examResult.SERVICE_TYPE_NAME = dict["SERVICE_TYPE_NAME"] as? String
                                    examResult.SERVICE_TYPE_NAME_AR = dict["SERVICE_TYPE_NAME_AR"] as? String
                                    examResult.STATUS_NAME = dict["STATUS_NAME"] as? String
                                    examResult.STATUS_NAME_AR = dict["STATUS_NAME_AR"] as? String
                                    examResult.PERMIT_VALIDITY = dict["PERMIT_VALIDITY"] as? String
                                    examResult.ASSESSMENT_DATE = dict["ASSESSMENT_DATE"] as? String
                                    
                                    
                                    examResultArray.append(examResult)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(examResultArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(examResultArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(examResultArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(examResultArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(examResultArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(examResultArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(examResultArray, false)
            }
        }
    
    
    
    }
    
    func submitfeedback(feedbackArray: [[String:Any]], completion: @escaping (Bool,String)-> () )
    {
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                print("\(appInstallGUID)")
              
                if let profileId = UserProfileDefaults.profileID {
                    let urlString = "http://83.111.121.89:338/LESMOBILEAPI/Masters/FeedbackSubmit"
                    guard let url = URL(string: urlString) else{
                        DispatchQueue.main.async {
                            completion(false,"Can not submit feedback")
                        }
                        return
                    }
                    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
                    request.httpMethod = "POST"
                    
                    let myDictOfDict:[String:Any] = [
                        "AppInstallGUID" :appInstallGUID,
                        "ProfileID" : profileId,
                        "feedback" : feedbackArray
                    ]
                    
                    print(myDictOfDict)
                    
                    
                    let jsonTodo: Data
                    do {
                        jsonTodo = try JSONSerialization.data(withJSONObject: myDictOfDict, options: [])
                        request.httpBody = jsonTodo
                    } catch {
                        
                        print("Error: cannot create JSON from todo")
                        DispatchQueue.main.async {
                            completion(false,"")
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
                                completion(false, "Can not submit feedback")
                            }
                            return
                        }
                        
                        do
                        {
                            guard let receivedData = data,  let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [String: AnyObject] else{
                                DispatchQueue.main.async {
                                    completion(false, "Can not submit feedback")
                                }
                                return
                            }
                            
                            let message = json["Message"] as? String
                            
                            //Checking for response code whether the response is success or not
                            if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                            {
                                DispatchQueue.main.async {
                                    if let messageText = message{
                                        completion(true, messageText)
                                    }
                                    
                                }
                            }
                            else //returning
                            {
                                DispatchQueue.main.async {
                                    completion(false, "Can not submit feedback")
                                }
                            }
                        }
                        catch let receivedError as NSError
                        {
                            DispatchQueue.main.async {
                                completion(false, "Can not submit feedback")
                            }
                            print(receivedError.localizedDescription)
                        }
                        }.resume()
                }else{
                    DispatchQueue.main.async {
                        completion(false, "Profile Id doesn't match")
                    }
                }
                
            }
            else{
                DispatchQueue.main.async {
                    completion(false, "App Install GUID is empty")
                }
            }
        }
        else{
            DispatchQueue.main.async {
                completion(false, "App Install Guid is null")
            }
        }
        
    }
    
    
    
    func checkComplaintStatus(fDate: String, toDate: String, completion: @escaping ([Complaint],Bool)-> ()){
//http://83.111.121.89:338/LESMOBILEAPI/Masters/ReadData?RequestType=GetComplaints&AppInstallGUID=1643F351-ECEF-4DC7-9166-82A4FD425B45&ProfileID=16039&CultureId=0
        var complaintArray = [Complaint]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
                        let urlString = serviceURL + "/ReadData?RequestType=\(getComplaints)&AppInstallGUID=\(appInstallGUID)&ProfileID=\(profileId)&CultureId=\(cultureIdEN)&FromDate=\(fDate)&ToDate=\(toDate)"
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
                                    completion(complaintArray, false)
                                }
                                return
                            }
                            do {
                                guard let recievedData = data else {
                                    DispatchQueue.main.async {
                                        completion(complaintArray, false)
                                    }
                                    return
                                }
                                if let stringData = String(data: recievedData, encoding: String.Encoding.utf8)  {
                                    print("Contains String Data")
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(complaintArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let complaint = Complaint()
                                    complaint.TRANS_NO = dict["TRANS_NO"] as? String
                                    complaint.COMPLAINT_ID = dict["COMPLAINT_ID"] as? Int
                                    complaint.AREA = dict["AREA"] as? String
                                    complaint.VEHICLE_NO = dict["VEHICLE_NO"] as? String
                                    complaint.COMPLAINT_TIME = dict["COMPLAINT_TIME"] as? String
                                    complaint.COMPLAINT_TYPE_EN = dict["COMPLAINT_TYPE_EN"] as? String
                                    complaint.COMPLAINT_TYPE_AR = dict["COMPLAINT_TYPE_AR"] as? String
                                    complaint.COMPLAINT_DET = dict["COMPLAINT_DET"] as? String
                                    complaint.STATUS_NAME = dict["STATUS_NAME"] as? String
                                    complaint.STATUS_NAME_AR = dict["STATUS_NAME_AR"] as? String
                                    complaint.COMPLAINER = dict["COMPLAINER"] as? String
                                    complaint.COMPLAINT_TYPE_ID = dict["COMPLAINT_TYPE_ID"] as? Int
                                    
                                    
                                    complaintArray.append(complaint)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(complaintArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(complaintArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(complaintArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(complaintArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(complaintArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(complaintArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(complaintArray, false)
            }
        }
        
        
        
    }
    
    func submitBookExam(centerId: String, type: String,examDate: String , remarks:String, questionairId: String ,completion: @escaping ([BookExamResponse],Bool)->()){
        
        var bookExamResponseArray = [BookExamResponse]()
        
        if let appInstallGUID = getAppInstallGUID() {
            if(appInstallGUID != ""){
                if let profileId = UserProfileDefaults.profileID {
                    if(profileId != ""){
                        
//                        http://83.111.121.89:338/LESMOBILEAPI/Masters/BookExam?AppInstallGUID=1B04FF58-95FF-4886-B571-CE58801E1C30&ServiceType=31102&ProfileID=8580&ServiceType=31102&ExamCenter=2868&Remarks=TEST&ExamDate=2018-01-12T10:00:00&QuestionaireId=3671
                        
                        let urlString = serviceURL + "/BookExam?AppInstallGUID=\(appInstallGUID)&ServiceType=\(type)&ProfileID=\(profileId)&ServiceType=\(type)&ExamCenter=\(centerId)&Remarks=\(remarks)&ExamDate=\(examDate)&QuestionaireId=\(questionairId)"
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
                                    completion(bookExamResponseArray, false)
                                }
                                return
                            }
                            do {
                                guard let recievedData = data else {
                                    return
                                }
                                if let stringData = String(data: recievedData, encoding: String.Encoding.utf8)  {
                                    print("Contains String Data")
                                }
                                guard let json = try JSONSerialization.jsonObject(with: recievedData, options: []) as? [[String: AnyObject]] else {
                                    DispatchQueue.main.async {
                                        completion(bookExamResponseArray, false)
                                    }
                                    return
                                }
                                
                                for dict in json {
                                    let res = BookExamResponse()
                                    res.SUCCESS = dict["SUCCESS"] as? Int
                                    res.MSG = dict["MSG"] as? String
                                    res.VALID_POSSIBLE_DATE = dict["VALID_POSSIBLE_DATE"] as? Date
                                    
                                    
                                    bookExamResponseArray.append(res)
                                }
                                
                                if let returnResponse = response as? HTTPURLResponse , 200...299 ~= returnResponse.statusCode
                                {
                                    DispatchQueue.main.async {
                                        completion(bookExamResponseArray, true)
                                    }
                                }
                                else //returning
                                {
                                    DispatchQueue.main.async {
                                        completion(bookExamResponseArray, false)
                                    }
                                }
                                
                            }catch let receivedError as NSError
                            {
                                print(receivedError.localizedDescription)
                                DispatchQueue.main.async {
                                    completion(bookExamResponseArray, false)
                                }
                            }
                            
                            }.resume()
                        
                    }else{
                        DispatchQueue.main.async {
                            completion(bookExamResponseArray, false)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(bookExamResponseArray, false)
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    completion(bookExamResponseArray, false)
                }
            }
            
        }else{
            DispatchQueue.main.async {
                completion(bookExamResponseArray, false)
            }
        }
        
    }
    
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
