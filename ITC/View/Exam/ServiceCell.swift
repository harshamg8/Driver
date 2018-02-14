//
//  ServiceCell.swift
//  ITC
//
//  Created by Harsha M G on 28/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bottomView.frame.origin.y = -self.contentView.frame.width
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomView.frame.origin.y = 1
            
        }, completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
