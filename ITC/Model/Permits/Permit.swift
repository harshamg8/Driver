//
//  Permit.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class Permit: NSObject {
    
    var PERMIT_STATUS_ID: Int?
    var PERMIT_STATUS_EN: String?
    var PERMIT_STATUS_AR: String?
    var PERMIT_ISSUE_DATE: String?
    var PERMIT_LAST_RENEW_DATE: String?
    var PERMIT_EXPIRY_DATE: String?
 
}

class PermitRenewalHistory: NSObject {
    var PERMIT_ISSUE_DATE: String?
    var PERMIT_EXPIRY_DATE: String?
    var PERMIT_RENEW_DATE: String?
    
    
}

class PermitSuspensionHistory: NSObject {
    var SUSPENSION_TYPE: String?
    var SUSPENSION_FROM: String?
    var SUSPENSION_DAYS: Int?
    var SUSPENSION_UNTIL: String?
    var IS_CLOSED_: Int?
    var COMPLETED: String?
    var SUSPENSION_REASON: String?
    var SUSPENSION_DOCUMENT: String?
    
    
}
