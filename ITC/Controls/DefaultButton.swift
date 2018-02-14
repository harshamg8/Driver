//
//  DefaultButton.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

@IBDesignable
class ReversedDefaultButton: DefaultButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewLayouts()
    }
    
    override func setupViewLayouts() {
        
        titleLabel?.font = masterButtonFont
        
        backgroundColor = masterTextColor
        layer.borderColor = masterColor.cgColor
        layer.cornerRadius = 3.0
        
        setTitleColor(masterColor, for: .normal)
    }
}

@IBDesignable
class DefaultButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewLayouts()
    }
    
    func setupViewLayouts() {
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 19.0)
        
        backgroundColor = masterColor
        layer.borderColor = masterTextColor.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 3.0
        
        setTitleColor(masterTextColor, for: .normal)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
