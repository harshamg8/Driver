//
//  PStatusView.swift
//  ITC
//
//  Created by Harsha M G on 13/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class PStatusView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var franchiseName: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var issueDateLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!
    
    override func awakeFromNib() {
        APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
            if(isCompleted){
                if let photoString = UserProfileDefaults.driverPhoto{
                    if let decodedData = Data(base64Encoded: photoString, options: .ignoreUnknownCharacters){
                        self.profileImageView.image = UIImage(data: decodedData)
                    }
                    
                }
                self.issueDateLabel.text = Helper.getCorrectDate(dateString: driverArray[1][1])
                self.expiryDateLabel.text = Helper.getCorrectDate(dateString: driverArray[1][3])
                self.permitNumberLabel.text = driverArray[1][0]
                
                if(UserProfileDefaults.isEnglish){
                    self.nameLabel.text = driverArray[2][0]
                    self.franchiseName.text = driverArray[0][0]
                    self.nationalityLabel.text = UserProfileDefaults.nationalityEn
                }else{
                    
                    if let array = DriverDetailsUserDefault.driverDetails {
                        self.nameLabel.text = array[2][0]
                        self.franchiseName.text = array[0][0]
                        self.nationalityLabel.text = UserProfileDefaults.nationalityAr
                    }
                    
                }
                
                
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


class SilverTaxiCardViewFront: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var franchiseLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var issueDateLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var operatigZoneLabel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!
    
    @IBOutlet weak var permitNoView: UIView!
    @IBOutlet weak var issuedateLabelView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var franchiseView: UIView!
    @IBOutlet weak var nationalityView: UIView!
    @IBOutlet weak var expryDateView: UIView!
    @IBOutlet weak var operationRegionView: UIView!
    
    
    override func awakeFromNib() {
        
        setBorderWidthAndColor(view: permitNoView)
        setBorderWidthAndColor(view: issuedateLabelView)
        setBorderWidthAndColor(view: nameView)
        setBorderWidthAndColor(view: franchiseView)
        setBorderWidthAndColor(view: nationalityView)
        setBorderWidthAndColor(view: expryDateView)
        setBorderWidthAndColor(view: operationRegionView)
        
        
        APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
            if(isCompleted){
                if let photoString = UserProfileDefaults.driverPhoto{
                    if let decodedData = Data(base64Encoded: photoString, options: .ignoreUnknownCharacters){
                        self.profileImageView.image = UIImage(data: decodedData)
                    }
                    
                }
                self.issueDateLabel.text = Helper.getCorrectDate(dateString: driverArray[1][1])
                self.expiryDateLabel.text = Helper.getCorrectDate(dateString: driverArray[1][3])
                self.permitNumberLabel.text = driverArray[1][0]
                
                if(UserProfileDefaults.isEnglish){
                    self.nameLabel.text = driverArray[2][0]
                    self.franchiseLabel.text = driverArray[0][0]
                    self.nationalityLabel.text = UserProfileDefaults.nationalityEn
                    self.operatigZoneLabel.text = UserProfileDefaults.operatigRegionEn
                    
                }else{
                    
                    if let array = DriverDetailsUserDefault.driverDetails {
                        self.nameLabel.text = array[2][0]
                        self.franchiseLabel.text = array[0][0]
                        self.nationalityLabel.text = UserProfileDefaults.nationalityAr
                        self.operatigZoneLabel.text = UserProfileDefaults.operatigRegionAr
                    }
                    
                }
                
                
                
            }
        }
        
    }
    
    func setBorderWidthAndColor(view: UIView){
        
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    
}

class AirportTaxiCardViewFront: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var franchiseLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var issueDateLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var operationRegionLAbel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var permitNumberView: UIView!
    @IBOutlet weak var issuedateView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var franchiseView: UIView!
    @IBOutlet weak var nationalityView: UIView!
    @IBOutlet weak var expirydateView: UIView!
    @IBOutlet weak var operatingRegionView: UIView!
    
    
    
    
    override func awakeFromNib() {
        
        setBorderWidthAndColor(view: permitNumberView)
        setBorderWidthAndColor(view: issuedateView)
        setBorderWidthAndColor(view: nameView)
        setBorderWidthAndColor(view: franchiseView)
        setBorderWidthAndColor(view: nationalityView)
        setBorderWidthAndColor(view: expirydateView)
        setBorderWidthAndColor(view: operatingRegionView)
        
        
        APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
            if(isCompleted){
                if let photoString = UserProfileDefaults.driverPhoto{
                    if let decodedData = Data(base64Encoded: photoString, options: .ignoreUnknownCharacters){
                        self.profileImageView.image = UIImage(data: decodedData)
                    }
                    
                }
                self.issueDateLabel.text = Helper.getCorrectDate(dateString: driverArray[1][1])
                self.expiryDateLabel.text = Helper.getCorrectDate(dateString: driverArray[1][3])
                self.permitNumberLabel.text = driverArray[1][0]
                
                if(UserProfileDefaults.isEnglish){
                    self.nameLabel.text = driverArray[2][0]
                    self.franchiseLabel.text = driverArray[0][0]
                    self.nationalityLabel.text = UserProfileDefaults.nationalityEn
                    self.operationRegionLAbel.text = UserProfileDefaults.operatigRegionEn
                    
                }else{
                    
                    if let array = DriverDetailsUserDefault.driverDetails {
                        self.nameLabel.text = array[2][0]
                        self.franchiseLabel.text = array[0][0]
                        self.nationalityLabel.text = UserProfileDefaults.nationalityAr
                        self.operationRegionLAbel.text = UserProfileDefaults.operatigRegionAr
                    }
                    
                }
                
                
                
            }
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func setBorderWidthAndColor(view: UIView){
        
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        
    }
    
    
}


class AirportTaxiAndSilverTaxiCardBack: UIView {
    
    @IBOutlet weak var certId: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        certId.text = UserProfileDefaults.certId
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    
}



class LimousineCardBack: UIView {
    
    override func awakeFromNib() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    
}


































