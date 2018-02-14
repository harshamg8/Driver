//
//  InevstigationScheduleCell.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class InevstigationScheduleCell: UITableViewCell {

    @IBOutlet weak var transtypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var transIdLabel: UILabel!
    @IBOutlet weak var transdateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var timeTextLabel: UILabel!
    @IBOutlet weak var centerTextLabel: UILabel!
    @IBOutlet weak var transactionIdTextLabel: UILabel!
    @IBOutlet weak var transactionDateTextLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(UserProfileDefaults.isEnglish){
            timeTextLabel.text = "Time"
            centerTextLabel.text = "Location"
            transactionIdTextLabel.text = "Transaction Id"
            transactionDateTextLabel.text = "Transaction Date"
            statusTextLabel.text = "Status"
        }else{
            timeTextLabel.text = NSLocalizedString("Time", comment: "")
            centerTextLabel.text = NSLocalizedString("Location", comment: "")
            transactionIdTextLabel.text = NSLocalizedString("Transaction Id", comment: "")
            transactionDateTextLabel.text = NSLocalizedString("Transaction Date", comment: "")
            statusTextLabel.text = NSLocalizedString("Status", comment: "")
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
    
    var schedule: InvestigationSchedule?
    {
        didSet{
            if let value = schedule?.INVESTIGATION_TIME {
                timeLabel.text = Helper.getCorrectDate(dateString: value)
            }else{
                timeLabel.text = "-"
            }
            if let value = schedule?.INVESTIGATION_CENTRE {
                centerLabel.text = value
            }else{
                centerLabel.text = "-"
            }
            if let value = schedule?.TRANS_ID {
                transIdLabel.text = String(value)
            }else{
                transIdLabel.text = "-"
            }
            if let value = schedule?.TRANS_DATE {
                transdateLabel.text = Helper.getCorrectDate(dateString: value)
            }else{
                transdateLabel.text = "-"
            }
            if let value = schedule?.STATUS_NAME {
                statusLabel.text = value
            }else{
                statusLabel.text = "-"
            }
            if let value = schedule?.TRANS_TYPE {
                transtypeLabel.text = value
            }else{
                transtypeLabel.text = "-"
            }
            
        }
    }

}
