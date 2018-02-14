//
//  BookExamController.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class BookExamController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var examCenterTextField: UITextField!
    @IBOutlet weak var remarksTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var examCenterTextLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var timeTextLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!
    
    let datePickerView: UIDatePicker = UIDatePicker()
    let timePickerView: UIDatePicker = UIDatePicker()
    let examCenterPickerView: UIPickerView = UIPickerView()
    var examCenterArray: [ExamCenterLookUp]?
    var bookExamResponseArray: [BookExamResponse]?
    var serviceType: String?
    var questionairId: Int?
    var examCenterId: String?
    var remarks = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileIdLabel.text = Helper.getProfileIdBasedOnTheLanguage()
        permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        
        if(UserProfileDefaults.isEnglish){
            examCenterTextLabel.text = "Exam Center"
            remarksLabel.text = "Remarks"
            dateTextLabel.text = "Date"
            timeTextLabel.text = "Time"
            self.navigationItem.title = "Book Exam"
            submitButton.setTitle("SUBMIT", for: .normal)
            examCenterTextField.placeholder = "Exam center"
            remarksTextField.placeholder = "Type remarks here"
            dateTextField.placeholder = "Date"
            timeTextField.placeholder = "Time"
        }else{
            
            examCenterTextLabel.text = NSLocalizedString("Exam Centre", comment: "")
            remarksLabel.text = NSLocalizedString("Remarks", comment: "")
            dateTextLabel.text = NSLocalizedString("Date", comment: "")
            timeTextLabel.text = NSLocalizedString("Time", comment: "")
            self.navigationItem.title = NSLocalizedString("Book Exam", comment: "")
            submitButton.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
            examCenterTextField.placeholder = NSLocalizedString("Exam Centre", comment: "")
            remarksTextField.placeholder = NSLocalizedString("Type the remarks here", comment: "")
            dateTextField.placeholder = NSLocalizedString("Date", comment: "")
            timeTextField.placeholder = NSLocalizedString("Time", comment: "")
            
        }
        
        setUpPickerViews()
        setUpToolBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpPickerViews() {
        dateTextField.inputView = datePickerView
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        timeTextField.inputView = timePickerView
        timePickerView.datePickerMode = .time
        timePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        examCenterPickerView.delegate = self
        examCenterPickerView.dataSource = self
        examCenterTextField.inputView = examCenterPickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let array = examCenterArray{
            return array.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let array = examCenterArray {
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
        if let array = examCenterArray {
            if(UserProfileDefaults.isEnglish){
                examCenterTextField.text = array[row].NAME_EN
            }else{
                examCenterTextField.text = array[row].NAME_AR
            }
            
            if let id = array[row].ID{
                examCenterId = String(id)
            }
        }else{
            examCenterTextField.text = ""
        }
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dateTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
        examCenterTextField.resignFirstResponder()
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
        examCenterTextField.inputAccessoryView = toolBar

    }
  
    
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        if(sender == datePickerView) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            dateTextField.text = formatter.string(from: sender.date)
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeTextField.text = formatter.string(from: sender.date)
        }
    }

    
  @IBAction func submitButtonTapped(_ sender: UIButton) {

    if let examdate = dateTextField.text, let timeString = timeTextField.text, let type = serviceType, let questionId = questionairId, let centerId = examCenterId {
        if (centerId  != "" && examdate != "" && timeString != "" && type != "") {
            //            2018-01-12T10:00:00
            let bookingDateString = "\(examdate)T\(timeString):00"
            self.bookExam(center: centerId, bookingDateTime: bookingDateString, type: type, questionId: questionId)
            
        }else{
            self.present(Alert.createErrorAlert(title: "Fields Empty", message: "None of the fields should be empty"), animated: true, completion: nil)
        }
    }else{
        self.present(Alert.createErrorAlert(title: "Sorry", message: "Service Type not availabele"), animated: true, completion: nil)
    }
    
    
    }
    
    func bookExam(center: String,  bookingDateTime: String, type: String, questionId: Int ){
        
        if let rmrks = remarksTextField.text {
            remarks = rmrks
        }else{
            remarks = ""
        }
        
        APIService.sharedInstance.submitBookExam(centerId: center, type: type, examDate: bookingDateTime, remarks: remarks, questionairId: String(questionId)) { (bookExamResponseArray, isCompleted) in
            if(isCompleted){
                self.bookExamResponseArray = bookExamResponseArray
                if let array = self.bookExamResponseArray{
                    if let success = array[0].SUCCESS{
                        
                        if (success == 1){
                            self.present(Alert.createErrorAlert(title: "Message", message: "Booking Confirmed"), animated: true, completion: nil)
                        }else if(success == -1){
                            if let msg = array[0].MSG{
                                self.present(Alert.createErrorAlert(title: "Sorry", message: "\(msg)"), animated: true, completion: nil)
                            }else{
                                self.present(Alert.createErrorAlert(title: "Sorry", message: "Failed to book Exam"), animated: true, completion: nil)
                            }
                        }else if (success == -99){
                            if let dateAndtime = array[0].VALID_POSSIBLE_DATE {
                                self.bookExamIfTimeSlotNotAvailabel(center: center, type: type, dateAndTime: String(describing: dateAndtime), questionId: questionId, remarks: self.remarks)
                            }else{
                                self.present(Alert.createErrorAlert(title: "Alert", message: "Can not book an appointment for entered date and time. Please select different time and date"), animated: true, completion: nil)
                            }
                        }
                    }else{
                        self.present(Alert.createErrorAlert(title: "Sorry", message: "Failed to book Exam"), animated: true, completion: nil)
                    }
                    
                }else{
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "Failed to book Exam"), animated: true, completion: nil)
                }
                
            }else{
                self.present(Alert.createErrorAlert(title: "Sorry", message: "Failed to book Exam. Try Again"), animated: true, completion: nil)
            }
        }
     
    }
    
    func bookExamIfTimeSlotNotAvailabel(center: String, type: String, dateAndTime: String, questionId: Int, remarks: String){
        
        let alert = UIAlertController(title: "Time Not Available", message: "Nearest available time:\(dateAndTime)\nClick OK to book exam else click Cancel", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.bookExam(center: center, bookingDateTime: dateAndTime, type: type, questionId: questionId)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

}
