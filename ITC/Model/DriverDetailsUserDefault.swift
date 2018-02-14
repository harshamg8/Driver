//
//  DriverDetailsUserDefault.swift
//  ITC
//
//  Created by Harsha M G on 21/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import Foundation
import UIKit

struct DriverDetailsUserDefault {
    
    static var driverName: String? {
        get {
            return UserDefaults.standard.value(forKey: "driverName") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "driverName")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var permitStatus: String? {
        get {
            return UserDefaults.standard.value(forKey: "permitStatus") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "permitStatus")
            UserDefaults.standard.synchronize()
        }
    }

    
    static var profileStatus: String? {
        get {
            return UserDefaults.standard.value(forKey: "profileStatus") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "profileStatus")
            UserDefaults.standard.synchronize()
        }
    }

    
    static var gender: String? {
        get {
            return UserDefaults.standard.value(forKey: "gender") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "gender")
            UserDefaults.standard.synchronize()
        }
    }

    
    static var nationality: String? {
        get {
            return UserDefaults.standard.value(forKey: "nationality") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "nationality")
            UserDefaults.standard.synchronize()
        }
    }

    
    static var religion: String? {
        get {
            return UserDefaults.standard.value(forKey: "religion") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "religion")
            UserDefaults.standard.synchronize()
        }
    }

    
    static var franchiseeName: String? {
        get {
            return UserDefaults.standard.value(forKey: "franchiseeName") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "franchiseeName")
            UserDefaults.standard.synchronize()
        }
    }

    
    static var franchiseeType: String? {
        get {
            return UserDefaults.standard.value(forKey: "franchiseeType") as? String
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "franchiseeType")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var driverDetails: [[String]]? {
        get {
            return UserDefaults.standard.value(forKey: "franchiseeType") as? [[String]]
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "franchiseeType")
            UserDefaults.standard.synchronize()
        }
    }


}

