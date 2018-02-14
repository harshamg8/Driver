//
//  TrainingController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class TrainingController: UIViewController {

    @IBOutlet weak var certificateButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var requirementButton: UIButton!
    @IBOutlet weak var carImageView: UIImageView!
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Training"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Training", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        carImageView.frame.origin.y = self.view.frame.height
        certificateButton.frame.origin.x = -128
        scheduleButton.frame.origin.x = 323
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.carImageView.frame.origin.y = 16
            self.certificateButton.frame.origin.x = 8
            self.scheduleButton.frame.origin.x = (self.certificateButton.frame.origin.x) + (self.scheduleButton.frame.width * 2)
            
        }, completion:nil)
        
        
        if (UserProfileDefaults.isEnglish) {
            certificateButton.setTitle("Certificates", for: .normal)
            scheduleButton.setTitle(" Schedule", for: .normal)
            requirementButton.setTitle("Requirement ", for: .normal)
            
        }else{
            certificateButton.setTitle(NSLocalizedString("Certificates", comment: ""), for: .normal)
            scheduleButton.setTitle(NSLocalizedString("Schedule", comment: ""), for: .normal)
            requirementButton.setTitle(NSLocalizedString("Required Training", comment: ""), for: .normal)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func certificateTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func scheduleTapped(_ sender: UIButton) {
        
    }
    
     @IBAction func requiredTapped(_ sender: UIButton) {
        
     }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
