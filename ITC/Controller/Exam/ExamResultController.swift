//
//  ExamResultController.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ExamResultController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var examResultTable: UITableView!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    
    @IBOutlet weak var fromDateTextLabel: UILabel!
    @IBOutlet weak var toDateTextLabel: UILabel!
    
    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    
    let fromDatePickerView: UIDatePicker = UIDatePicker()
    let toDatePickerView: UIDatePicker = UIDatePicker()
    
    
    var examResultArray: [ExamResult]?
    var unFilteredArray: [ExamResult]?
    
    var vw = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        noRecordFoundLabel.text = ""
        if(UserProfileDefaults.isEnglish){
            fromDateTextLabel.text = "From Date"
            toDateTextLabel.text = "To Date"
            filterButton.setTitle("Filter", for: .normal)
            fromDateTextField.placeholder = "From Date"
            toDateTextField.placeholder = "To Date"
        }else{
            fromDateTextLabel.text = NSLocalizedString("From Date", comment: "")
            toDateTextLabel.text = NSLocalizedString("To Date", comment: "")
            filterButton.setTitle(NSLocalizedString("Filter", comment: ""), for: .normal)
            fromDateTextField.placeholder = NSLocalizedString("From Date", comment: "")
            toDateTextField.placeholder = NSLocalizedString("To Date", comment: "")
        }
        
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Exam Results"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Exam Results", comment: "")
        }

        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        examResultTable.delegate = self
        examResultTable.dataSource = self
        
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
        toDateTextField.text = formatter2.string(from: todaydateInDate)
        self.examResultArray?.removeAll()
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            APIService.sharedInstance.fetchExamResult(fDate: fromDateString , toDate: todayDateString , completion: { (examResultArray, isCompleted) in
                if(isCompleted){
                    self.examResultArray = examResultArray
                    self.removeActivityIndicatorView()
                    self.noRecordFoundLabel.text = ""
                    self.examResultTable.reloadData()
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records found"), animated: true, completion: nil)
                    self.noRecordFoundLabel.text = "No Records found"
                }
                
            })
        }else{
            self.noRecordFoundLabel.text = "No Internet"
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
        toDateTextField.inputView = toDatePickerView
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
        toDateTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        fromDateTextField.text = formatter.string(from: fromDatePickerView.date)
        toDateTextField.text = formatter.string(from: toDatePickerView.date)
        fromDateTextField.resignFirstResponder()
        toDateTextField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        if(sender == fromDatePickerView) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            fromDateTextField.text = formatter.string(from: sender.date)
            
        }else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            toDateTextField.text = formatter.string(from: sender.date)
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        if(textField == fromDateTextField){
            
            if let fDate = formatter.date(from: fromDateTextField.text!){
                fromDatePickerView.setDate(fDate, animated: true)
            }
            
        }else{
            if let tDate = formatter.date(from: toDateTextField.text!){
                toDatePickerView.setDate(tDate, animated: true)
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
                if let array = examResultArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ExamResultCell
        
        if let array = examResultArray {
            cell.examResult = array[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
         self.noRecordFoundLabel.text = ""
        if let fDateString = fromDateTextField.text, let tDateString = toDateTextField.text {
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
                self.examResultArray?.removeAll()
                APIService.sharedInstance.fetchExamResult(fDate: fromDateString , toDate: todateString , completion: { (examResultArray, isCompleted) in
                    if(isCompleted){
                        self.examResultArray = examResultArray
                        self.removeActivityIndicatorView()
                        self.noRecordFoundLabel.text = ""
                        self.examResultTable.reloadData()
                    }else{
                        self.removeActivityIndicatorView()
                        self.examResultTable.reloadData()
                        self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records found"), animated: true, completion: nil)
                        self.noRecordFoundLabel.text = "No Records found"
                    }
                    
                })
              
              
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
