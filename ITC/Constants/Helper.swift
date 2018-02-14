//
//  Helper.swift
//  ITC
//
//  Created by Harsha M G on 02/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class Helper: NSObject{
    
    
    static func getCorrectDate(dateString: String) -> String {
        
        var dateStringComponents = dateString.components(separatedBy: "T")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let datefromString = formatter.date(from: dateStringComponents[0])
        if let value = datefromString {
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.string(from: value)
        }else{
            return dateStringComponents[0]
        }
        
    }
    
    static func getCorrectTime(dateString: String) -> String {

    let dateStringComponents = dateString.components(separatedBy: "T")
    let t = dateStringComponents[1].components(separatedBy: ".")
    return t[0]
    
    }
    
    
    static func getProfileIdBasedOnTheLanguage() -> String {
        if(UserProfileDefaults.isEnglish){
            if let id = UserProfileDefaults.profileID{
                return "Profile Id: \(id)"
            }else{
                return "Profile Id:"
            }
        }else{
            if let id = UserProfileDefaults.profileID{
                return "\(NSLocalizedString("Profile", comment: "")): \(id)"
            }else{
                return "\(NSLocalizedString("Profile", comment: "")):"
            }
        }
        
        
            
    }
    static func getPermitNumberBasedOnTheLanguage() -> String {
        if(UserProfileDefaults.isEnglish){
            if let number = UserProfileDefaults.permitNumber{
                return "Permit No \(number)"
            }else{
                return "Permit No"
            }
        }else{
            if let number = UserProfileDefaults.permitNumber{
                return "\(NSLocalizedString("Permit number", comment: "")): \(number)"
            }else{
                return "\(NSLocalizedString("Permit number", comment: "")):"
            }
        }
    }
    
    
    
    static func getDate(dateString: String) -> Date {
        
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
        if let dateFromString = formatter.date(from: dateString) {
            return dateFromString
        }
        return Date()
    }
    
}

import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
}













