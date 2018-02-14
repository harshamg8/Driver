//
//  CarRenewHistoryCell.swift
//  ITC
//
//  Created by Harsha M G on 12/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class CarRenewHistoryCell: UITableViewCell {

    @IBOutlet weak var taxiNumberTextLabel: UILabel!
    @IBOutlet weak var stickerNumberTextLabel: UILabel!
    
    @IBOutlet weak var expiryDateTextLabel: UILabel!
    @IBOutlet weak var renewdateTextLabel: UILabel!
    
    @IBOutlet weak var taxiNumberLabel: UILabel!
    @IBOutlet weak var stickerNumberLabel: UILabel!
    @IBOutlet weak var renewDateLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.frame.origin.y = -self.contentView.frame.width
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomView.frame.origin.y = 1
            
        }, completion: nil)
        
        if(UserProfileDefaults.isEnglish){
            taxiNumberTextLabel.text = "Taxi Number"
            stickerNumberTextLabel.text = "Sticker Number"
            renewdateTextLabel.text = "Renew Date"
            expiryDateTextLabel.text = "Expiry Date"
        }else{
            taxiNumberTextLabel.text = NSLocalizedString("Vehicle Number", comment: "")
            stickerNumberTextLabel.text = NSLocalizedString("Sticker Number", comment: "")
            renewdateTextLabel.text = NSLocalizedString("Renewal date", comment: "")
            expiryDateTextLabel.text = NSLocalizedString("Expiry date", comment: "")
            
        }
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var renewHistory: VehicleRenewalHistory? {
        didSet{
            if let obj = renewHistory?.TAXI_NUMBER{
                taxiNumberLabel.text = "\(obj)"
            }
            if let obj = renewHistory?.STICKER_NO{
                stickerNumberLabel.text = obj
            }
            if let obj = renewHistory?.RENEW_DATE{
                renewDateLabel.text = Helper.getCorrectDate(dateString: obj)
            }
            if let obj = renewHistory?.EXIPRY_DATE{
                expiryDateLabel.text = Helper.getCorrectDate(dateString: obj)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
