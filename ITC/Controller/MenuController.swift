//
//  MenuController.swift
//  ITC
//
//  Created by Harsha M G on 19/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class MenuController: UIViewController {

    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var profileIdLabel: UILabel!
    
    @IBOutlet weak var permitNumberNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photoString = UserProfileDefaults.driverPhoto{
            if let decodedData = Data(base64Encoded: photoString, options: .ignoreUnknownCharacters){
                driverImageView.image = UIImage(data: decodedData)
            }
            
        }else{
            
        }
        
        profileIdLabel.text = Helper.getProfileIdBasedOnTheLanguage()
        permitNumberNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        
        if(UserProfileDefaults.isEnglish){
            logoutButton.setTitle("Logout", for: .normal)

        }else{
            logoutButton.setTitle(NSLocalizedString("Logout", comment: ""), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        profileIdLabel.text = Helper.getProfileIdBasedOnTheLanguage()
        permitNumberNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        
        if(UserProfileDefaults.isEnglish){
            logoutButton.setTitle("Logout", for: .normal)
            changePasswordButton.setTitle("Change Password", for: .normal)
            
            
        }else{
            logoutButton.setTitle(NSLocalizedString("Logout", comment: ""), for: .normal)
            changePasswordButton.setTitle(NSLocalizedString("Change Password", comment: ""), for: .normal)
        }
        
       
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        UserProfileDefaults.profileID = nil
        UserProfileDefaults.isLoggedIn = false
        UserProfileDefaults.permitNumber = nil
        UserProfileDefaults.driverPhoto = nil
        DriverDetailsUserDefault.driverDetails = nil
        UserProfileDefaults.mobileNumber = nil
        UserProfileDefaults.nationalityAr = nil
        UserProfileDefaults.nationalityEn = nil
        UserProfileDefaults.operatigRegionAr = nil
        UserProfileDefaults.operatigRegionEn = nil
        UserProfileDefaults.certId = nil
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "siginIn") as! SignInController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
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
