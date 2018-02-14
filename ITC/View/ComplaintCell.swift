//
//  ComplaintCell.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ComplaintCell: UITableViewCell {

    @IBOutlet weak var transactionNumberLabel: UILabel!
    @IBOutlet weak var vehicleNumberLabel: UILabel!
    @IBOutlet weak var complaintNameLael: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var complaintDetailLabel: UILabel!
    @IBOutlet weak var complaintStatusLabel: UILabel!
    @IBOutlet weak var complainerLabel: UILabel!
    
    @IBOutlet weak var transactionnumberTextLabel: UILabel!
    @IBOutlet weak var vehicleNumberTextLabel: UILabel!
    @IBOutlet weak var areaTextLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var complainerTestLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(UserProfileDefaults.isEnglish){
            transactionnumberTextLabel.text = "Transaction Number"
            vehicleNumberTextLabel.text = "Vehicle Number"
            statusTextLabel.text = "Status"
            areaTextLabel.text = "Area"
            complainerTestLabel.text = "Complainer"
            
        }else{
            transactionnumberTextLabel.text = NSLocalizedString("Transaction Number", comment: "")
            vehicleNumberTextLabel.text = NSLocalizedString("Vehicle Number", comment: "")
            statusTextLabel.text = NSLocalizedString("Status", comment: "")
            areaTextLabel.text = NSLocalizedString("Area", comment: "")
            complainerTestLabel.text = NSLocalizedString("Complainer", comment: "")
        }
        
        bottomView.frame.origin.y = -self.contentView.frame.width
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomView.frame.origin.y = 1
            
        }, completion: nil)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var complaint: Complaint?
    {
        didSet{
            if let value = complaint?.TRANS_NO {
                transactionNumberLabel.text = value
            }else{
                transactionNumberLabel.text = "-"
            }
            if let value = complaint?.VEHICLE_NO {
                vehicleNumberLabel.text = value
            }else{
                vehicleNumberLabel.text = "-"
            }
            if(UserProfileDefaults.isEnglish){
                if let value = complaint?.COMPLAINT_TYPE_EN {
                    complaintNameLael.text = value
                }else{
                    complaintNameLael.text = "-"
                }
            }else{
                if let value = complaint?.COMPLAINT_TYPE_AR {
                    complaintNameLael.text = value
                }else{
                    complaintNameLael.text = "-"
                }
            }
            
            if let value = complaint?.COMPLAINER {
                complainerLabel.text = value
            }else{
                complainerLabel.text = "-"
            }
            
            if let value = complaint?.AREA {
                areaLabel.text = value
            }else{
                areaLabel.text = "-"
            }
            
            if(UserProfileDefaults.isEnglish){
                if let value = complaint?.STATUS_NAME {
                    complaintStatusLabel.text = value
                }else{
                    complaintStatusLabel.text = "-"
                }
            }else{
                if let value = complaint?.STATUS_NAME_AR {
                    complaintStatusLabel.text = value
                }else{
                    complaintStatusLabel.text = "-"
                }
            }
            
            if let value = complaint?.COMPLAINT_DET {
                complaintDetailLabel.text = value
            }else{
                complaintDetailLabel.text = "-"
            }
        }
    }

}
