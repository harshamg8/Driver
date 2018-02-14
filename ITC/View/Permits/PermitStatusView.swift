//
//  PermitStatusView.swift
//  ITC
//
//  Created by Harsha M G on 29/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class PermitStatusView: UICollectionViewCell {
   
//    @IBOutlet weak var statusTextLabel: UILabel!
//    @IBOutlet weak var statusLabel: UILabel!
//
//    @IBOutlet weak var issuedateTextLabel: UILabel!
//    @IBOutlet weak var issueDateLabel: UILabel!
//
//    @IBOutlet weak var renewalDateTextLabel: UILabel!
//    @IBOutlet weak var renewalDateLabel: UILabel!
//
//    @IBOutlet weak var expiryDateTextLabel: UILabel!
//    @IBOutlet weak var expiryDateLabel: UILabel!
    
    @IBOutlet weak var abc: CardView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if(UserProfileDefaults.isEnglish){
//            statusTextLabel.text = "Status"
//            issuedateTextLabel.text = "Issue Date"
//            renewalDateTextLabel.text = "Renewal Date"
//            expiryDateTextLabel.text = "Expiry Date"
//        }else{
//            statusTextLabel.text = NSLocalizedString("Status", comment: "")
//            issuedateTextLabel.text = NSLocalizedString("Permit Issue Date", comment: "")
//            renewalDateTextLabel.text = NSLocalizedString("Renewal date", comment: "")
//            expiryDateTextLabel.text = NSLocalizedString("Expiry date", comment: "")
//        }
        abc.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        abc.frame = CGRect.init(x: 0, y: 20, width: 411, height: 316)
        

    }
    
//    var statusArray: [Permit]? {
//        didSet{
//            if let array = statusArray{
//                if(UserProfileDefaults.isEnglish){
//                    statusLabel.text = array[0].PERMIT_STATUS_EN
//                }else{
//                    statusLabel.text = array[0].PERMIT_STATUS_AR
//                }
//                if let obj = array[0].PERMIT_ISSUE_DATE{
//                    issueDateLabel.text = Helper.getCorrectDate(dateString: obj)
//                }
//                if let obj = array[0].PERMIT_LAST_RENEW_DATE{
//                    renewalDateLabel.text = Helper.getCorrectDate(dateString: obj)
//                }
//                if let obj = array[0].PERMIT_EXPIRY_DATE{
//                    expiryDateLabel.text = Helper.getCorrectDate(dateString: obj)
//                }
//            }
//        }
//    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
    
