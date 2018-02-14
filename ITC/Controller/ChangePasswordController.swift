//
//  ChangePasswordController.swift
//  ITC
//
//  Created by Harsha M G on 08/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var permitNumberLabel: UILabel!
    @IBOutlet weak var profileIdLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelbutton: UIButton!
    
    @IBOutlet weak var newPasswordTextLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        confirmPasswordTextField.isEnabled = false
        confirmPasswordTextField.alpha = 0.7
        permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        profileIdLabel.text = Helper.getProfileIdBasedOnTheLanguage()
        
        carImageView.frame.origin.y = self.view.frame.height
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.carImageView.frame.origin.y = 45
            
        }, completion:nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        profileIdLabel.text = Helper.getProfileIdBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            submitButton.setTitle("SUBMIT", for: .normal)
            cancelbutton.setTitle("CANCEL", for: .normal)
            newPasswordTextField.placeholder = "New Password"
            newPasswordTextLabel.text = "New Password"
            confirmPasswordTextField.placeholder = "Confirm Password"
            confirmPasswordTextLabel.text = "Confirm Password"
            navigationItem.title = "Change Password"
        }else{
            submitButton.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
            cancelbutton.setTitle(NSLocalizedString("CANCEL", comment: ""), for: .normal)
            newPasswordTextField.placeholder = NSLocalizedString("New Password", comment: "")
            newPasswordTextLabel.text = NSLocalizedString("New Password", comment: "")
            confirmPasswordTextField.placeholder = NSLocalizedString("Confirm Password", comment: "")
            confirmPasswordTextLabel.text = NSLocalizedString("Confirm Password", comment: "")
            navigationItem.title = NSLocalizedString("Change Password", comment: "")
        }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == newPasswordTextField){
            confirmPasswordTextField.isEnabled = true
            confirmPasswordTextField.alpha = 1
            if(newPasswordTextField.text == confirmPasswordTextField.text){
                submitButton.isEnabled = true
                submitButton.alpha = 1
            }
            
        }else{
            if(newPasswordTextField.text == confirmPasswordTextField.text){
                submitButton.isEnabled = true
                submitButton.alpha = 1
            }else{
                present(Alert.createErrorAlert(title: "Alert", message: "New password and Confirm password should match"), animated: true, completion: nil)
                submitButton.alpha = 0.5
                submitButton.isEnabled = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if(newPasswordTextField.text == confirmPasswordTextField.text){
            
            dismiss(animated: true, completion: nil)
            
        }else{
            present(Alert.createErrorAlert(title: "Alert", message: "New password and Confirm password should match"), animated: true, completion: nil)
        }
        
        
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
