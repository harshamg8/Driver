                //
//  SelectDateAndTimeInvestigationController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class SelectDateAndTimeInvestigationController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var centerTextField: UITextField!
    @IBOutlet weak var remarkstextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var centerTextLabel: UILabel!
    @IBOutlet weak var remarksTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var timeTextLabel: UILabel!
    @IBOutlet weak var bookInvestigationButton: UIButton!
    
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!
   
    
    var centerArray: [InvestigationCenter]?
    var investigationBookingResponseArray: [BoolInvestigationResponse]?
    var vw = UIView()
    let datePickerView: UIDatePicker = UIDatePicker()
    let timePickerView: UIDatePicker = UIDatePicker()
    let centerPickerView: UIPickerView = UIPickerView()
    var centerId = String()
   
    var transtype: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Book Investigation"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Book Investigation", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            APIService.sharedInstance.fetchInvestigationCenterLookup { (investigationCenterArray, isCompleted) in
                if(isCompleted){
                    self.centerArray = investigationCenterArray
                    self.removeActivityIndicatorView()
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "Centers not found"), animated: true, completion: nil)
                }
            }
        }else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
       
        
        if(UserProfileDefaults.isEnglish){
            centerTextLabel.text = "Center"
            remarksTextLabel.text = "Remarks"
            dateTextLabel.text = "Date"
            timeTextLabel.text = "Time"
            
            bookInvestigationButton.setTitle("Book Investigation", for: .normal)
            remarkstextField.placeholder = "Type remarks here"
            dateTextField.placeholder = "Date"
            timeTextField.placeholder = "Time"
        }else{
            
            remarksTextLabel.text = NSLocalizedString("Remarks", comment: "")
            dateTextLabel.text = NSLocalizedString("Date", comment: "")
            timeTextLabel.text = NSLocalizedString("Time", comment: "")
            
            bookInvestigationButton.setTitle(NSLocalizedString("Book Investigation", comment: ""), for: .normal)
            centerTextLabel.text = "Center"
            remarkstextField.placeholder = NSLocalizedString("Type the remarks here", comment: "")
            dateTextField.placeholder = NSLocalizedString("Date", comment: "")
            timeTextField.placeholder = NSLocalizedString("Time", comment: "")
            
        }
        
        
        
        
        setUpPickerViews()
        setUpToolBar()
        
        
        let myBackButton:UIButton = UIButton(type: .custom) as UIButton
        // myBackButton.addTarget(self, action: Selector("goback"), for: UIControlEvents.touchUpInside)
        
        myBackButton.addTarget(self, action: #selector(goback), for: .touchUpInside)
        
        // myBackButton.setTitle("", for: .normal)
        myBackButton.setTitleColor(UIColor.white, for: .normal)
        myBackButton.setImage(UIImage.init(named: "back"), for: .normal)
        
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == centerTextField){
            if(centerTextField.text == ""){
                self.centerPickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(centerPickerView.self, didSelectRow: 0, inComponent: 0)
            }
        }
        if (textField == dateTextField){
            if(dateTextField.text == ""){
                datePickerValueChanged(sender: datePickerView)
            }
        }
    }
    
    
    @objc func goback(){
        let refreshAlert = UIAlertController(title: "Wait", message: "Are you sure you want to exit?" , preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
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

    
    
    func setUpPickerViews() {
        dateTextField.inputView = datePickerView
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        timeTextField.inputView = timePickerView
        timePickerView.datePickerMode = .time
        timePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        centerPickerView.delegate = self
        centerPickerView.dataSource = self
        centerTextField.inputView = centerPickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let array = centerArray{
            return array.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let array = centerArray {
            if(UserProfileDefaults.isEnglish){
                return array[row].NAME_EN
            }else{
                return array[row].NAME_AR
            }
            
        }else{
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let array = centerArray {
            if(UserProfileDefaults.isEnglish){
                centerTextField.text = array[row].NAME_EN
            }else{
                centerTextField.text = array[row].NAME_AR
            }
            
            
            if let id = array[row].ID{
                self.centerId = String(id)
            }else{
                self.centerId = ""
            }
       }else{
            centerTextField.text = ""
        }
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dateTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        centerTextField.resignFirstResponder()
    }
    
    func setUpToolBar(){
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.rgb(red: 184, green: 41, blue: 37)
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(donePressed))
        toolBar.setItems([okBarBtn], animated: true)
        dateTextField.inputAccessoryView = toolBar
        timeTextField.inputAccessoryView = toolBar
        centerTextField.inputAccessoryView = toolBar
        
    }
    
    
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        if(sender == datePickerView) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            dateTextField.text = formatter.string(from: sender.date)
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeTextField.text = formatter.string(from: sender.date)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookInvestigationTapped(_ sender: UIButton) {
        
        if let examdate = dateTextField.text, let timeString = timeTextField.text, let type = transtype {
            if (centerId  != "" && examdate != "" && timeString != "" && type != "") {
                //            2018-01-12T10:00:00
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                guard let d = formatter.date(from: examdate) else{
                    return
                }
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "yyyy-MM-dd"
                let d2 = formatter2.string(from: d)
                let bookingDateString = "\(d2)T\(timeString):00"
                self.bookAppointment(center: centerId, bookingDateTime: bookingDateString, type: type)

            }else{
                self.present(Alert.createErrorAlert(title: "Fields Empty", message: "None of the fields should be empty"), animated: true, completion: nil)
            }
        }else{
            self.present(Alert.createErrorAlert(title: "Sorry", message: "Service Type not availabele"), animated: true, completion: nil)
        }
        
        
 }
    
    func bookAppointment(center: String,  bookingDateTime: String, type: String ){
        InvestigationAPI.sharedInstance.bookInvestigationAppointment(centerId: center, transId: type, time: bookingDateTime, completion: { (investigationResponseArray, isCompleted) in
            if(isCompleted){
                self.investigationBookingResponseArray = investigationResponseArray
                if let array = self.investigationBookingResponseArray {
                    if let success = array[0].SUCCESS{
                        
                        if (success == 1){
                            self.present(Alert.createErrorAlert(title: "Message", message: "Booking Confirmed"), animated: true, completion: nil)
                        }else if(success == -1){
                            if let msg = array[0].MSG{
                                self.present(Alert.createErrorAlert(title: "Sorry", message: "\(msg)"), animated: true, completion: nil)
                            }else{
                                self.present(Alert.createErrorAlert(title: "Sorry", message: "Failed to book appointment"), animated: true, completion: nil)
                            }
                            
                        }else if (success == -99){
                            if let dateAndtime = array[0].VALID_POSSIBLE_DATE {
                                self.bookAppointmnetIfTimeSlotNotAvailabel(center: center, type: type, dateAndTime: String(describing: dateAndtime))
                            }else{
                                self.present(Alert.createErrorAlert(title: "Alert", message: "Can not book an appointment for entered date and time. Please select different time and date"), animated: true, completion: nil)
                            }
                        }
                    }
                    
                }else{
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "Failed to book appointment"), animated: true, completion: nil)
                }
            }else{
                self.present(Alert.createErrorAlert(title: "Sorry", message: "Failed to book appointment"), animated: true, completion: nil)
            }
          
        })
    }
    
    func bookAppointmnetIfTimeSlotNotAvailabel(center: String, type: String, dateAndTime: String){
        
        let alert = UIAlertController(title: "Time Not Available", message: "Nearest available time:\(dateAndTime)\nClick Done to book appointment else click Cancel", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.bookAppointment(center: center, bookingDateTime: dateAndTime, type: type)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
