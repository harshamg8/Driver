//
//  SuspensionHistoryCell.swift
//  ITC
//
//  Created by Harsha M G on 29/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class SuspensionHistoryCell: UITableViewCell {

    @IBOutlet weak var suspensionreasonLabel: UILabel!
    
    @IBOutlet weak var typeTextLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var fromTextLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var untilTextLabel: UILabel!
    @IBOutlet weak var untilLabel: UILabel!
    
    @IBOutlet weak var ststusTextLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    
    var suspension: PermitSuspensionHistory?{
        didSet{
            if let obj = suspension?.SUSPENSION_REASON {
                suspensionreasonLabel.text = obj
            }
            if let obj = suspension?.SUSPENSION_TYPE {
                typeLabel.text = obj
            }
            if let obj = suspension?.SUSPENSION_FROM {
                fromLabel.text = Helper.getCorrectDate(dateString: obj)
            }
            if let obj = suspension?.SUSPENSION_UNTIL {
                untilLabel.text = Helper.getCorrectDate(dateString: obj)
            }
            if let obj = suspension?.COMPLETED {
                if(obj == "Yes"){
                    statusLabel.text = "Completed"
                }else{
                    statusLabel.text = "Not Completed"
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomView.layer.cornerRadius = 15
        bottomView.layer.masksToBounds = true
        topView.layer.cornerRadius = 10
        topView.layer.masksToBounds = true
        if(UserProfileDefaults.isEnglish){
            typeTextLabel.text = "Type"
            fromTextLabel.text = "From"
            untilTextLabel.text = "Until"
            ststusTextLabel.text = "Status"
        }else{
            typeTextLabel.text = NSLocalizedString("Type", comment: "")
            fromTextLabel.text = NSLocalizedString("From", comment: "")
            untilTextLabel.text = NSLocalizedString("Until", comment: "")
            ststusTextLabel.text = NSLocalizedString("Status", comment: "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
