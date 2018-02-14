//
//  Alert.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    var okEn: String = "OK"
    var okAr: String = "حسنا"
    static func createErrorAlert(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if(UserProfileDefaults.isEnglish){
            let alertOk = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertOk)
        }else{
            let alertOk = UIAlertAction(title: "حسنا", style: .default, handler: nil)
            alert.addAction(alertOk)
        }
        
        
        
        return alert
    }
}
