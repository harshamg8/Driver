//
//  Constants.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import Foundation
import UIKit

let serviceURL = "http://83.111.121.89:338/LESMOBILEAPI/Masters"

let keychainService = "ITC"
let keychainAccount = "ITCAccount"
let keychainData = UIDevice.current.identifierForVendor
let deviceID = KeychainService.loadPassword(service: keychainService, account: keychainAccount)

let masterColor = UIColor.red
let masterTextColor = UIColor.black

let masterLabelFont = UIFont.boldSystemFont(ofSize: 11.0)
let masterButtonFont = UIFont.boldSystemFont(ofSize: 12.0)

let cultureIdEN = 0
let cultureIdAr = 1

let grievanceSubCatLookup = "GrievanceSubCatLookup"
let grievanceTypeLookup = "GrievanceTypeLookup"
let serviceLookup = "ServiceLookup"
let ivestigationLookup = "InvestigationCenterLookup"
let violReversalTypeLookup = "ViolReversalTypeLookup"
let examCenterLookup = "ExamCenterLookup"
let franchiseTypeLookup = "FranchiseTypeLookup"
let oprRegionLookup = "OprRegionLookup"
let licenseSourcelookup = "LicenseSourcelookup"
let permitStatusLookup = "PermitStatusLookup"
let driverStatusLookup = "DriverStatusLookup"
let driver = "Driver"
let driverFines = "DriverFines"
let grievanceSubmit = "GrievanceSubmit"
let getWhitePoint = "GetWhitePoint"
let getBlackPoint = "GetBlackPoint"
let checkExamStatus = "CheckExamStatus"
let examResult = "ExamResult"
let checkPermitStatus = "CheckPermitStatus"
let getComplaints = "GetComplaints"
let checkOPQTime = "CheckOPQTime"
let getVehicleStatus = "GetVehicleStatus"
let getVehRenHistory = "GetVehRenHistory"
let training = "Training"
let trnCertificates = "TrnCertificates"
let trainingSchedule = "TrainingSchedule"
let trainingReq = "TrainingReq"
let getOperatingZone = "GetOperatingZone"
let listforInvestBooking = "ListforInvestBooking"
let viewInvestSchedule = "ViewInvestSchedule"
let viewNotification = "ViewNotification"
let permitRenewHistory = "PermitRenewHistory"
let driverSuspension = "DriverSuspension"
let feedbackQuestion = "FeedbackQuestion"
let feedbackQstOpt = "FeedbackQstOpt"

