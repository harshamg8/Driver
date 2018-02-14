//
//  HomeCollectionViewCell.swift
//  ITC
//
//  Created by Harsha M G on 14/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    let menuImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    let menuLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name:"Avenir Next", size: 13.0)
        label.numberOfLines = 2
        return label
    }()
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        addSubview(menuImageView)
        addSubview(menuLabel)

        addConstraints(with: "H:|-8-[v0]-8-|", views: menuImageView)
        addConstraints(with: "V:|-2-[v0]-6-[v1]-8-|", views: menuImageView,menuLabel)

        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    
    
}
