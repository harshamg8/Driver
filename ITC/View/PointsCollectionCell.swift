//
//  PointsCollectionCell.swift
//  ITC
//
//  Created by Harsha M G on 15/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class PointsCollectionCell: UICollectionViewCell {
 
    let pointNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        addSubview(pointNameLabel)
        addConstraints(with: "H:|[v0]|", views: pointNameLabel)
        addConstraints(with: "V:|[v0]|", views: pointNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
