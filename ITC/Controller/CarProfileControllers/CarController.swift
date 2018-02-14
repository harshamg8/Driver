//
//  CarController.swift
//  ITC
//
//  Created by Harsha M G on 12/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class CarController: UIViewController {

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var vehicleStatusButton: UIButton!
    @IBOutlet weak var vehicleRenewHistoryButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Car"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Car", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        if(UserProfileDefaults.isEnglish){
            vehicleStatusButton.setTitle("Vehicle Profile", for: .normal)
            vehicleRenewHistoryButton.setTitle("History", for: .normal)
        }else{
            vehicleStatusButton.setTitle(NSLocalizedString("Vehicle Profile", comment:" "), for: .normal)
            vehicleRenewHistoryButton.setTitle(NSLocalizedString("History", comment: ""), for: .normal)
        }
        
        
        carImageView.frame.origin.y = self.view.frame.height
        vehicleStatusButton.frame.origin.x = -128
        vehicleRenewHistoryButton.frame.origin.x = 323
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.carImageView.frame.origin.y = 16
            self.vehicleStatusButton.frame.origin.x = 8
            self.vehicleRenewHistoryButton.frame.origin.x = (self.vehicleStatusButton.frame.origin.x) + (self.vehicleRenewHistoryButton.frame.width * 2)
            
        }, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
