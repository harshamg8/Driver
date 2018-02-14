//
//  ComplaintController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ComplaintController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    var vw = UIView()
    var complaintArray: [Complaint]?
     var unFilteredArray: [Complaint]?
    
    @IBOutlet weak var complainttableView: UITableView!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    
    @IBOutlet weak var fromDateTextLabel: UILabel!
    @IBOutlet weak var toDateTextLabel: UILabel!
    
    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var tpDateTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    
    let fromDatePickerView: UIDatePicker = UIDatePicker()
    let toDatePickerView: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if(UserProfileDefaults.isEnglish){
            fromDateTextLabel.text = "From Date"
            toDateTextLabel.text = "To Date"
            filterButton.setTitle("Filter", for: .normal)
            fromDateTextField.placeholder = "From Date"
            tpDateTextField.placeholder = "To Date"
        }else{
            fromDateTextLabel.text = NSLocalizedString("From Date", comment: "")
            toDateTextLabel.text = NSLocalizedString("To Date", comment: "")
            filterButton.setTitle(NSLocalizedString("Filter", comment: ""), for: .normal)
            
            fromDateTextField.placeholder = NSLocalizedString("From Date", comment: "")
            tpDateTextField.placeholder = NSLocalizedString("To Date", comment: "")
        }
        
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Complaints"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Complaints", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        complainttableView.delegate = self
        complainttableView.dataSource = self
       
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = formatter.string(from: todayDate)
        guard let todaydateInDate = formatter.date(from: todayDateString) else{
            return
        }
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -30, to: todaydateInDate) else{
            return
        }
        let fromDateString = formatter.string(from: fromDate)
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd-MM-yyyy"
        fromDateTextField.text = formatter2.string(from: fromDate)
        tpDateTextField.text = formatter2.string(from: todaydateInDate)
        self.complaintArray?.removeAll()
        self.noRecordFoundLabel.text = ""
        
        if(Reachability.isConnectedToNetwork()){
        setupActivityIndicator()
        APIService.sharedInstance.checkComplaintStatus(fDate: fromDateString, toDate: todayDateString) { (complaintsArray, isCompleted) in
            if(isCompleted){
                self.removeActivityIndicatorView()
                self.complaintArray = complaintsArray
                self.noRecordFoundLabel.text = ""
                self.complainttableView.reloadData()
                
            }else{
                self.removeActivityIndicatorView()
                self.noRecordFoundLabel.text = "No Records found"
                self.present(Alert.createErrorAlert(title: "Sorry", message: "No Record found"), animated: true, completion: nil)
            }
        }
    } else{
        noRecordFoundLabel.text = "No Internet"
        self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
    }
        
        setUpToolBar()
        setUpPickerViews()
      
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
        fromDateTextField.inputView = fromDatePickerView
        fromDatePickerView.datePickerMode = .date
        fromDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        tpDateTextField.inputView = toDatePickerView
        toDatePickerView.datePickerMode = .date
        toDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
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
        tpDateTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        fromDateTextField.resignFirstResponder()
        tpDateTextField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        if(sender == fromDatePickerView) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            fromDateTextField.text = formatter.string(from: sender.date)
            
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            tpDateTextField.text = formatter.string(from: sender.date)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 287
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = complaintArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ComplaintCell
        
        if let array = complaintArray{
            cell.complaint = array[indexPath.row]
        }else{
            return cell
        }
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        if(textField == fromDateTextField){
            
            if let fDate = formatter.date(from: fromDateTextField.text!){
                fromDatePickerView.setDate(fDate, animated: true)
            }
            
        }else{
            if let tDate = formatter.date(from: tpDateTextField.text!){
                toDatePickerView.setDate(tDate, animated: true)
            }
        }
    }
    
    
    
  
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        self.noRecordFoundLabel.text = ""
        if let fDateString = fromDateTextField.text, let tDateString = tpDateTextField.text {
            if(fDateString != "" && tDateString != ""){
                setupActivityIndicator()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                guard let fdate = formatter.date(from: fDateString) else{
                    return
                }
                guard let tDate = formatter.date(from: tDateString) else{
                    return
                }
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "yyyy-MM-dd"
                let fromDateString = formatter2.string(from: fdate)
                let todateString = formatter2.string(from: tDate)
                self.complaintArray?.removeAll()
                APIService.sharedInstance.checkComplaintStatus(fDate: fromDateString, toDate: todateString) { (complaintsArray, isCompleted) in
                    if(isCompleted){
                        self.removeActivityIndicatorView()
                        self.complaintArray = complaintsArray
                        self.noRecordFoundLabel.text = ""
                        self.complainttableView.reloadData()
                        
                    }else{
                        self.removeActivityIndicatorView()
                        self.complainttableView.reloadData()
                        self.noRecordFoundLabel.text = "No Records found"
                        self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records found"), animated: true, completion: nil)
                    }
                }
                
                
            }
            
        }
        
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
