//
//  RenewalHistoryCell.swift
//  ITC
//
//  Created by Harsha M G on 29/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class RenewalHistoryCell: UITableViewCell {

    @IBOutlet weak var isuueDateTextLabel: UILabel!
    @IBOutlet weak var isuueDateLabel: UILabel!
    
    @IBOutlet weak var expiryDateTextLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    @IBOutlet weak var renewalDateTextLabel: UILabel!
    @IBOutlet weak var renewalDateLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var history: PermitRenewalHistory? {
        didSet{
           
            if let obj = history?.PERMIT_EXPIRY_DATE{
                expiryDateLabel.text = Helper.getCorrectDate(dateString: obj)
            }
            if let obj = history?.PERMIT_RENEW_DATE{
                renewalDateLabel.text = Helper.getCorrectDate(dateString: obj)
            }
            if let obj = history?.PERMIT_ISSUE_DATE{
                isuueDateLabel.text = Helper.getCorrectDate(dateString: obj)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomView.layer.cornerRadius = 15
        bottomView.layer.masksToBounds = true
        
        if(UserProfileDefaults.isEnglish){
            isuueDateTextLabel.text = "Issue Date"
            expiryDateTextLabel.text = "Expiry Date"
            renewalDateTextLabel.text = "Renew Date"
        }else{
            isuueDateTextLabel.text = NSLocalizedString("Permit Issue Date", comment: "")
            expiryDateTextLabel.text = NSLocalizedString("Expiry date", comment: "")
            renewalDateTextLabel.text = NSLocalizedString("Renewal date", comment: "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
