//
//  ComplaintSelectDateController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ComplaintSelectDateController: UIViewController {

    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var fromDateTextLabel: UILabel!
    @IBOutlet weak var toDateTextLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    
    
    
    
    var fDate = ""
    var tDate = ""
    let fromDatePickerView: UIDatePicker = UIDatePicker()
    let toDatePickerView: UIDatePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserProfileDefaults.isEnglish){
            fromDateTextLabel.text = "From Date"
            toDateTextLabel.text = "To Date"
            fromDateTextField.placeholder = "From Date"
            toDateTextField.placeholder = "To Date"
            submitButton.setTitle("SUBMIT", for: .normal)
            navigationItem.title = "Date"
        }else{
            fromDateTextLabel.text = NSLocalizedString("From Date", comment: "")
            toDateTextLabel.text = NSLocalizedString("To Date", comment: "")
            fromDateTextField.placeholder = NSLocalizedString("From Date", comment: "")
            toDateTextField.placeholder = NSLocalizedString("To Date", comment: "")
            submitButton.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
            navigationItem.title = NSLocalizedString("Date", comment: "")
        }
        
        setUpToolBar()
        setUpPickerViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPickerViews() {
        fromDateTextField.inputView = fromDatePickerView
        fromDatePickerView.datePickerMode = .date
        fromDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        toDateTextField.inputView = toDatePickerView
        toDatePickerView.datePickerMode = .date
        toDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        fromDateTextField.resignFirstResponder()
        toDateTextField.resignFirstResponder()
    }
    
    func setUpToolBar(){
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.rgb(red: 184, green: 41, blue: 37)
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(donePressed))
        toolBar.setItems([okBarBtn], animated: true)
        fromDateTextField.inputAccessoryView = toolBar
        toDateTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        if(sender == fromDatePickerView) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            fromDateTextField.text = formatter.string(from: sender.date)
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            toDateTextField.text = formatter.string(from: sender.date)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func checkComplaintButtonTapped(_ sender: UIButton) {
        if let fromDate = fromDateTextField.text, let toDate = toDateTextField.text {
            if(fromDate != "" && toDate != ""){
                self.fDate = fromDate
                self.tDate = toDate
                self.performSegue(withIdentifier: "toComplaint", sender: self)
            }else{
                
            }
        
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toComplaint") {
            //let vc = segue.destination as! ComplaintController
            
        }
        
        
        
        
        
        
    
        
    }
}
