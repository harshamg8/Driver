//
//  DriverFineCell.swift
//  ITC
//
//  Created by Harsha M G on 15/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func clicked(driverFine:DriverFine,forCell cell:DriverFineCell)
    func googleMapsButtonClicked(driverFine:DriverFine,forCell cell:DriverFineCell)
}

class DriverFineCell: UITableViewCell {

    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var fineNumberLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var fineAmountLabel: UILabel!
    @IBOutlet weak var blackPointLabel: UILabel!
    @IBOutlet weak var submitGrievanceButton: UIButton!
    @IBOutlet weak var botomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var fineNumberTextTextLabel: UILabel!
    @IBOutlet weak var locationTextLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var fineTextLabel: UILabel!
    @IBOutlet weak var blackPointsTextLabel: UILabel!
    @IBOutlet weak var googleMapButton: UIButton!
    
    
    
    
    var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
        botomView.layer.cornerRadius = 15
        botomView.layer.masksToBounds = true
        topView.layer.cornerRadius = 10
        topView.layer.masksToBounds = true
        submitGrievanceButton.layer.cornerRadius = 5
        submitGrievanceButton.layer.masksToBounds = true
        
        botomView.frame.origin.y = -self.contentView.frame.width
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.botomView.frame.origin.y = 1
            
        }, completion: nil)
        
        if(UserProfileDefaults.isEnglish){
            fineNumberTextTextLabel.text = "Fine Number"
            locationTextLabel.text = "Location"
            statusTextLabel.text = "Status"
            fineTextLabel.text = "Amount"
            blackPointsTextLabel.text = "Black points"
            submitGrievanceButton.setTitle("Grievance", for: .normal)
        }else{
            fineNumberTextTextLabel.text = NSLocalizedString("Fine Number", comment: "")
            locationTextLabel.text = NSLocalizedString("Location", comment: "")
            statusTextLabel.text = NSLocalizedString("Status", comment: "")
            fineTextLabel.text = NSLocalizedString("Amount", comment: "")
            blackPointsTextLabel.text = NSLocalizedString("Black points", comment: "")
            submitGrievanceButton.setTitle(NSLocalizedString("Grievance", comment: ""), for: .normal)
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
    var driverFine: DriverFine? {
        didSet{
           
            if(UserProfileDefaults.isEnglish){
                if let articleName = driverFine?.ARTICLE_NAME {
                    if let code = driverFine?.ARTICLE_CODE{
                        articleNameLabel.text = "\(code) - \(articleName)"
                    }else{
                        articleNameLabel.text = articleName
                    }
                    
                }
            }else{
                if let articleName = driverFine?.ARTICLE_NAME_AR {
                    if let code = driverFine?.ARTICLE_CODE{
                        articleNameLabel.text = "\(code) - \(articleName)"
                    }else{
                        articleNameLabel.text = articleName
                    }
                }
            }
            
            if let fineNumber = driverFine?.FINE_NO {
                fineNumberLabel.text = fineNumber
            }
            if let location = driverFine?.LOCATION_NAME {
                locationLabel.text = location
            }
            if let amount = driverFine?.DRIVER_FINE_AMOUNT{
                fineAmountLabel.text = String(describing: amount)
            }
            if let blackPoints = driverFine?.DRIVER_BLACK_POINTS{
                blackPointLabel.text = String(describing: blackPoints)
            }
            
            if(UserProfileDefaults.isEnglish){
                if let status = driverFine?.STATUS_NAME {
                    statusLabel.text = status
                }
            }else{
                if let status = driverFine?.STATUS_NAME_AR {
                    statusLabel.text = status
                }
            }
            
            if let isPossibleForGrievance = driverFine?.IS_POSSIBLE_FOR_GREVIENCE {
                if (isPossibleForGrievance == 1){
                    submitGrievanceButton.isHidden = false
                    submitGrievanceButton.alpha = 1
                    submitGrievanceButton.addTarget(self, action: #selector(submitGrievanceButtonPressed), for: .touchUpInside)
                }else{
                    submitGrievanceButton.isHidden = true
                    submitGrievanceButton.alpha = 0.5
                    
                }
            }
            googleMapButton.addTarget(self, action: #selector(googleMapButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func submitGrievanceButtonPressed() {
        if let del = delegate {
            if let fine = driverFine {
                del.clicked(driverFine: fine, forCell: self)
            }
            
        }
    }
    
   @objc func googleMapButtonPressed(){
    
    if let del = delegate{
        if let fine = driverFine{
            del.googleMapsButtonClicked(driverFine: fine, forCell: self)

        }
    }
   
    
    }

}




















