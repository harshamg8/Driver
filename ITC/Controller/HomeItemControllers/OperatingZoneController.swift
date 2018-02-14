//
//  OperatingZoneController.swift
//  ITC
//
//  Created by Harsha M G on 17/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class OperatingZoneController: UIViewController {
    
    @IBOutlet weak var operatingInLabel: UILabel!
    @IBOutlet weak var operatingRegionTextLabel: UILabel!
    
    var operatingZoneArray: [OperatingZone]?
    var vw = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        
        if(UserProfileDefaults.isEnglish){
            self.navigationItem.title = "Opeariong Region"
            operatingRegionTextLabel.text = "Operating Zone:"
            
        }else{
            self.navigationItem.title = NSLocalizedString("Operating Region", comment: "")
            operatingRegionTextLabel.text = NSLocalizedString("Operating Region", comment: "")
        }
        
        
        APIService.sharedInstance.fetchVehicleOperatingZone { (operatingZoneArray, isCompleted) in
            if(isCompleted){
                self.operatingZoneArray = operatingZoneArray
                self.removeActivityIndicatorView()
                if let array = self.operatingZoneArray{
                    if(UserProfileDefaults.isEnglish){
                        self.operatingInLabel.text = array[0].REGION_NAME_EN
                    }else{
                        self.operatingInLabel.text = array[0].REGION_NAME_AR
                    }
                    
                }else{
                    self.operatingInLabel.text = "Not Available"
                }
            }else{
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "Sorry", message: "No Record Found"), animated: true, completion: nil)
            }
        }
        
    }

    func setupActivityIndicator(){
        vw = UIView(frame:CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        vw.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.addSubview(vw)
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        myActivityIndicator.hidesWhenStopped = false
        view.bringSubview(toFront: vw)
        vw.addSubview(myActivityIndicator)
        myActivityIndicator.center = vw.center
        myActivityIndicator.startAnimating()
    }
    func removeActivityIndicatorView(){
        self.vw.removeFromSuperview()
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
