//
//  BookInvestigationCell.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

protocol CheckBookButtonClicked {
    func didClickBookButton(violation:BookInvestigation,forCell cell:BookInvestigationCell)
}


class BookInvestigationCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var fineDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var tranTypeLabel: UILabel!
    @IBOutlet weak var numberTextLabel: UILabel!
    @IBOutlet weak var fineDateTextLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var delegate: CheckBookButtonClicked?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bottomView.frame.origin.y = -self.contentView.frame.width
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomView.frame.origin.y = 1
            
        }, completion: nil)
        
        if(UserProfileDefaults.isEnglish){
            numberTextLabel.text = "Number"
            fineDateTextLabel.text = "Date"
            statusTextLabel.text = "Status"
            bookButton.setTitle("Book", for: .normal)
        }else{
            numberTextLabel.text = NSLocalizedString("Number", comment: "")
            fineDateTextLabel.text = NSLocalizedString("Date", comment: "")
            statusTextLabel.text = NSLocalizedString("Status", comment: "")
            bookButton.setTitle("احجز", for: .normal)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var violation: BookInvestigation?
    {
        didSet{
            
            if let value = violation?.TRANS_NO {
                numberLabel.text = value
            }else{
                numberLabel.text = "-"
            }
            if let value = violation?.TRANS_DATE{
                fineDateLabel.text =  Helper.getCorrectDate(dateString: value)
            }else{
                fineDateLabel.text = "-"
            }
            if let value = violation?.STATUS_NAME {
                statusLabel.text = value
            }else{
                statusLabel.text = "-"
            }
            if let value = violation?.TRANS_TYPE {
                tranTypeLabel.text = value
            }else{
                tranTypeLabel.text = "-"
            }
            bookButton.addTarget(self, action: #selector(bookButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc func bookButtonPressed(){
        if let viol = violation{
            delegate?.didClickBookButton(violation: viol, forCell: self)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
