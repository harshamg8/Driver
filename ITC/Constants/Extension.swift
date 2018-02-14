//
//  Extension.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    var length: Int {
        return count
    }
    
    var trimmedLength: Int {
        return trimmingCharacters(in: .whitespacesAndNewlines).length
    }
}

extension UIColor {
        
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
            
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


    

