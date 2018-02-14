//
//  UserProfileDefaults.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import Foundation


struct UserProfileDefaults {
    
    static var profileID: String? {
        get {
            return UserDefaults.standard.value(forKey: "profileID") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "profileID")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var permitNumber: String? {
        get {
            return UserDefaults.standard.value(forKey: "permitNumber") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "permitNumber")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var appInstallGUID: String? {
        get {
            return UserDefaults.standard.value(forKey: "appInstallGUID") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "appInstallGUID")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var driverPhoto: String? {
        get {
            return UserDefaults.standard.value(forKey: "driverPhoto") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "driverPhoto")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var mobileNumber: String? {
        
        get {
            return UserDefaults.standard.value(forKey: "mobileNumber") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "mobileNumber")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    static var nationalityEn: String? {
        
        get {
            return UserDefaults.standard.value(forKey: "nationalityEn") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "nationalityEn")
            UserDefaults.standard.synchronize()
        }
        
    }
    

    static var nationalityAr: String? {
        
        get {
            return UserDefaults.standard.value(forKey: "nationalityAr") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "nationalityAr")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    static var operatigRegionEn: String? {
        
        get {
            return UserDefaults.standard.value(forKey: "operatigRegionEn") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "operatigRegionEn")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    static var operatigRegionAr: String? {
        
        get {
            return UserDefaults.standard.value(forKey: "operatigRegionAr") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "operatigRegionAr")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    static var certId: String? {
        
        get {
            return UserDefaults.standard.value(forKey: "certId") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "certId")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    
    static var isLoggedOut: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedOut")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isLoggedOut")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isEnglish: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isEnglish")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isEnglish")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
}
