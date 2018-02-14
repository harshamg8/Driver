//
//  PermitCardBackSideCell.swift
//  ITC
//
//  Created by Harsha M G on 13/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class PermitCardBackSideCell: UICollectionViewCell {

   
    @IBOutlet weak var abc: BackCardView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        abc.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        abc.frame = CGRect.init(x: 0, y: 20, width: 411, height: 316)
    }

}
