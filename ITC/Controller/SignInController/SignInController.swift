//
//  SignInController.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    @IBOutlet weak var mainImageVIew: UIImageView!
    @IBOutlet weak var permitNumberImageView: UIImageView!
    @IBOutlet weak var dateOfBirthImageView: UIImageView!
    @IBOutlet weak var permitNumberTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    //let fromDatePickerView: UIDatePicker = UIDatePicker()

    var vw = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if(!Reachability.isConnectedToNetwork()){
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }

      
        
        dateOfBirthTextField.keyboardType = .numberPad
        
        signInButton.setTitle("Login / \(NSLocalizedString("Login", comment: ""))", for: .normal)
        permitNumberTextField.placeholder = "Permit Number / \(NSLocalizedString("Permit number", comment: ""))"
      dateOfBirthTextField.placeholder = "(ddmmyyyy)DOB/\(NSLocalizedString("Date of birth", comment: ""))"
        
        permitNumberImageView.layer.cornerRadius = permitNumberImageView.frame.size.width / 2
        permitNumberImageView.layer.masksToBounds = true
        dateOfBirthImageView.layer.cornerRadius = permitNumberImageView.frame.width
            / 2
        dateOfBirthImageView.layer.masksToBounds = true
        signInButton.layer.cornerRadius = 15
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tap)
        
       
        
       

    }

    
    /*
    func setUpPickerViews() {
        dateOfBirthTextField.inputView = fromDatePickerView
        fromDatePickerView.datePickerMode = .date
        fromDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dateOfBirthTextField.resignFirstResponder()
    }
    
    func setUpToolBar(){
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.rgb(red: 184, green: 41, blue: 37)
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(donePressed))
        toolBar.setItems([okBarBtn], animated: true)
        dateOfBirthTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        if(sender == fromDatePickerView) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            dateOfBirthTextField.text = formatter.string(from: sender.date)
        }
    }
    */
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            RegisterWebService.sharedInstance.registerDevice(completion: { (isCompleted) in
                if(isCompleted){
                    if (UserProfileDefaults.appInstallGUID != nil && UserProfileDefaults.appInstallGUID != "") {
                        if let permitNumber = self.permitNumberTextField.text, let dob = self.dateOfBirthTextField.text {
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "ddMMyyyy"
                            guard let dobDateDDMMYYYY = formatter.date(from: dob) else{
                                
                                self.removeActivityIndicatorView()
                                self.show( Alert.createErrorAlert(title: "No Profile ID!", message: "Incorrect Permit number or DOB"), sender: self)
                                return
                            }
                            let formatterNew = DateFormatter()
                            formatterNew.dateFormat = "MM-dd-yyyy"
                            let dobStringMM_dd_yyyy = formatterNew.string(from: dobDateDDMMYYYY)
                            
                            
                            
                            let dobString = self.getCorretDate(dateString: dob)
                            APIService.sharedInstance.getProfileIdFromService(permitNumber: permitNumber, dob: dobStringMM_dd_yyyy, completion: { (hasGotProfileId) in
                                if(hasGotProfileId){
                                    self.removeActivityIndicatorView()
                                    DispatchQueue.main.async {[unowned self] in
                                        UserProfileDefaults.isLoggedIn = true
                                        UserProfileDefaults.permitNumber = permitNumber
                                        self.performSegue(withIdentifier: "toMainMenu", sender: self)
                                        
                                    }
                                }else{
                                    DispatchQueue.main.async {[unowned self] in
                                        self.removeActivityIndicatorView()
                                        self.show( Alert.createErrorAlert(title: "No Profile ID!", message: "Incorrect Permit number or DOB"), sender: self)
                                    }
                                    
                                }
                            })
                            
                        }
                    }
                }else{
                    
                }
            })
        }
        else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func getCorretDate(dateString: String) -> String{
        var finalDateString = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if let dateFromString = formatter.date(from: dateString){
            let formatterNew = DateFormatter()
            formatterNew.dateFormat = "MM-dd-yyyy"
            finalDateString = formatterNew.string(from: dateFromString)
        }else{
             finalDateString = ""
        }
       return finalDateString
    }
   
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
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
