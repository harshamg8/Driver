//
//  TrainingModel.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class TrainingCertificate: NSObject {
    
 
    
    var COURSE_NAME_EN: String?
    var COURSE_NAME_AR: String?
    var CHAPTER_ID: Int?
    var CHAPTER_CODE: Int?
    var CHAPTER_NAME_EN: String?
    var CHAPTER_NAME_AR: String?
    var VALIDITY: String?
}

class TrainingSchedule: NSObject {
    
    var COURSE_NAME_EN: String?
    var COURSE_NAME_AR: String?
    var CHAPTER_ID: Int?
    var CHAPTER_CODE: Int?
    var CHAPTER_NAME_EN: String?
    var CHAPTER_NAME_AR: String?
    var SCHEDULE_DATE: String?
    var COURSE_CODE: Int?
}

class REquiredTraining: NSObject {
  
    
    var TRAINING_SOURCE_TYPE_ID: Int?
    var TRAINING_SOURCE_EN: String?
    var TRAINING_SOURCE_AR: String?
    var COURSE_CODE: Int?
    var COURSE_NAME_EN: String?
    var COURSE_NAME_AR: String?
    var CHAPTER_ID: Int?
    var CHAPTER_CODE: Int?
    var CHAPTER_NAME_EN: String?
    var CHAPTER_NAME_AR: String?
    var SUSPENSION_DATE: String?
    var IS_SUSPENDED: Int?
    var REQUIRED_BEFORE: String?
    var SUSPENSION_STATUS: String?
    
    
}
