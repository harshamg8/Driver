//
//  SwitchView.swift
//  ITC
//
//  Created by Harsha M G on 20/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit


protocol SegmentedControlClicked {
    func didSegmetedControlTapped(isEnglishSelected: Bool, object: SwitchView)
}

class SwitchView: UIView {
    
    @IBOutlet weak var switchSegmentedControl: UISegmentedControl!
    var delegate: SegmentedControlClicked?
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        if switchSegmentedControl.selectedSegmentIndex == 0 {
           UserProfileDefaults.isEnglish = true
            delegate?.didSegmetedControlTapped(isEnglishSelected: true, object: self)
        }else{
            UserProfileDefaults.isEnglish = false
            delegate?.didSegmetedControlTapped(isEnglishSelected: false, object: self)
        }
        
        
        
    }
}
