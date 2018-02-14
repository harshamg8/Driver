//
//  DriverFineController.swift
//  ITC
//
//  Created by Harsha M G on 15/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class DriverFineController: UIViewController, UITableViewDelegate,UITableViewDataSource, CellDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var fineTableView: UITableView!
    @IBOutlet weak var noRecordsFound: UILabel!
    
    @IBOutlet weak var fromDateTextLabel: UILabel!
    @IBOutlet weak var toDateTextLabel: UILabel!
    
  
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    
    let fromDatePickerView: UIDatePicker = UIDatePicker()
    let toDatePickerView: UIDatePicker = UIDatePicker()
    
    var vw = UIView()
    let cellId = "cellId"
    
    var driverFineArray: [DriverFine]?
    var unFilteredArray: [DriverFine]?
    
    var driverFine: DriverFine?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.noRecordsFound.text = ""
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
            titleView.PageTitleLabel.text = "Fines"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Fines", comment: "")
        }
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        fineTableView.dataSource = self
        fineTableView.delegate = self
        
        
        
        driverFine = DriverFine()
        setUpToolBar()
        setUpPickerViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        
        self.driverFineArray?.removeAll()
        if(Reachability.isConnectedToNetwork()){
            
            setupActivityIndicator()
            APIService.sharedInstance.fetchDriverFines(fDate: fromDateString, toDate: todayDateString) { (driverFinesArray, isCompleted) in
                if(isCompleted){
                    self.removeActivityIndicatorView()
                    self.driverFineArray = driverFinesArray
                    self.fineTableView.reloadData()
                    self.noRecordsFound.text = ""
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records found"), animated: true, completion: nil)
                    self.noRecordsFound.text = "No Records found"
                    
                }
            }
            
        }else{
             self.noRecordsFound.text = "No Internet"
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
    
    
    @objc func doSomething(){
        
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
    
    func setUpPickerViews() {
        fromDateTextField.inputView = fromDatePickerView
        fromDatePickerView.datePickerMode = .date
        fromDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        toDateTextField.inputView = toDatePickerView
        toDatePickerView.datePickerMode = .date
        toDatePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let selection = fineTableView.indexPathForSelectedRow {
        fineTableView.deselectRow(at: selection, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let array = self.driverFineArray{
            return array.count
        }else{
            return 0

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId , for: indexPath) as! DriverFineCell
        if let array = self.driverFineArray{
            cell.driverFine = array[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //driverFine = driverFineArray[indexPath.row]
       
    }
    
    func clicked(driverFine: DriverFine, forCell cell: DriverFineCell) {
        self.driverFine = driverFine
        performSegue(withIdentifier: "toSubmitGrievance", sender: self)
    }
    
    func googleMapsButtonClicked(driverFine: DriverFine, forCell cell: DriverFineCell) {
        
        if let coordinates = driverFine.GPS_COORDINATES{
            if coordinates != "" {
            var coordinateComponents = coordinates.components(separatedBy: ",")
//            UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=&daddr=\(coordinateComponents[0]),\(coordinateComponents[1])&directionsmode=driving")!)
            
            
//                UIApplication.shared.openURL(URL(string:
//                    "comgooglemaps://?saddr=&daddr=\(coordinateComponents[0]),\(coordinateComponents[1])")!)
            guard let url = URL(string: "comgooglemaps://") else{
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                if(coordinateComponents.count == 2){
                    if(coordinateComponents[0] != "" && coordinateComponents[1] != ""){
                        guard let mapUrl = URL(string:
                            "comgooglemaps://?center=\(coordinateComponents[0]),\(coordinateComponents[1])&zoom=10&views=traffic") else{
                                present(Alert.createErrorAlert(title: "Sorry", message: "Can't open Google Maps"), animated: true, completion: nil)
                                return
                        }
                        
                        UIApplication.shared.openURL(mapUrl)
                    }
                   
                }
                
            }else{
                
                present(Alert.createErrorAlert(title: "Sorry", message: "Can't open Google Maps"), animated: true, completion: nil)
            }
          
            }else{
                present(Alert.createErrorAlert(title: "Coordinates are missing", message: "Can't open Google Maps."), animated: true, completion: nil)
                }
        }else{
            present(Alert.createErrorAlert(title: "Coordinates are missing", message: "Can't open Google Maps."), animated: true, completion: nil)
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSubmitGrievance"{
            let submitGrievance = segue.destination as! SubmitGrievanceController
            
            if(UserProfileDefaults.isEnglish){
                
                if let value = driverFine?.ARTICLE_NAME {
                    submitGrievance.articleName = value
                }
                if let value = driverFine?.VIOLATION_ID {
                    submitGrievance.violationId = value
                }
                if let value = driverFine?.LOCATION_NAME {
                    submitGrievance.locationName = value
                }
                if let value = driverFine?.STATUS_NAME {
                    submitGrievance.status = value
                }
                if let value = driverFine?.FINE_NO {
                    submitGrievance.fineNumber = value
                }
                
            }else{
                
                if let value = driverFine?.ARTICLE_NAME_AR {
                    submitGrievance.articleName = value
                }
                if let value = driverFine?.VIOLATION_ID {
                    submitGrievance.violationId = value
                }
                if let value = driverFine?.LOCATION_NAME {
                    submitGrievance.locationName = value
                }
                if let value = driverFine?.STATUS_NAME_AR {
                    submitGrievance.status = value
                }
                if let value = driverFine?.FINE_NO {
                    submitGrievance.fineNumber = value
                }
                
            }
            
            
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
    
    
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
         self.noRecordsFound.text = ""
        if let fDateString = fromDateTextField.text, let tDateString = toDateTextField.text {
            if(fDateString != "" && tDateString != ""){
                
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
                self.driverFineArray?.removeAll()
                setupActivityIndicator()
                APIService.sharedInstance.fetchDriverFines(fDate: fromDateString, toDate: todateString) { (driverFinesArray, isCompleted) in
                    if(isCompleted){
                        self.removeActivityIndicatorView()
                        self.driverFineArray = driverFinesArray
                        self.noRecordsFound.text = ""
                        self.fineTableView.reloadData()
                    }else{
                        self.removeActivityIndicatorView()
                        self.fineTableView.reloadData()
                        self.present(Alert.createErrorAlert(title: "Sorry", message: "Driver fines not found"), animated: true, completion: nil)
                        self.noRecordsFound.text = "No Records found"
                    }
                }

                
            }
            
        }
    }
    
    
    
    
    
    
}
