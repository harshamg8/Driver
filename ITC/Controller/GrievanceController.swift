//
//  GrievanceController.swift
//  ITC
//
//  Created by Harsha M G on 22/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class GrievanceController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource,GrievanceCellDelegate,UITextFieldDelegate {

    @IBOutlet weak var serviceTypeTextLabel: UILabel!
    @IBOutlet weak var operatingRegionTextLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var serviceTypeTextField: UITextField!
    @IBOutlet weak var operatingRegionTExtField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var complaintTableView: UITableView!
    
    
    var complaintId = Int()
    var remarks : String = ""
    var tableArray = [CoplaintCategeoryAndRemarks]()
    
    
    var vw = UIView()
    var grievanceTypeArray: [GrievanceTypeLookUp]?
    var operatingRegionArray: [OperatingRegionLookup]?
    
    let grievancePickerView = UIPickerView()
    let operatingRegionPickerView = UIPickerView()
    
    var grievanceId: Int?
    var operatingRegionId: Int?
    var complaintCategoryId: Int?
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        addButton.isUserInteractionEnabled = false
        addButton.alpha = 0.5
      
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Grievance"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Grievance", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        
        let complaintcategoryAndRemarsk =  CoplaintCategeoryAndRemarks()
        self.tableArray.removeAll()
        self.tableArray.append(complaintcategoryAndRemarsk)
        
       
        if(UserProfileDefaults.isEnglish){
            serviceTypeTextLabel.text = "Grievance"
            operatingRegionTextLabel.text = "Operating Region"
            
            serviceTypeTextField.placeholder = "Grievance"
            operatingRegionTExtField.placeholder = "Operating Region"
            
            submitButton.setTitle("SUBMIT", for: .normal)
        }else{
            serviceTypeTextLabel.text = NSLocalizedString("Grievance", comment: "")
            operatingRegionTextLabel.text = NSLocalizedString("Operating Region", comment: "")
            
            serviceTypeTextField.placeholder = NSLocalizedString("Grievance", comment: "")
            operatingRegionTExtField.placeholder = NSLocalizedString("Operating Region", comment: "")
           
            submitButton.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
        }
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            GrievanceTypeAndSubCategoryLookUpAPI.sharedInstance.fetchGrievanceTypeLookUps { (grievanceTypeArray, isCompleted) in
                if(isCompleted){
                    self.removeActivityIndicatorView()
                    self.grievanceTypeArray = grievanceTypeArray
                }else{
                    self.removeActivityIndicatorView()
                }
            }
            
            
            APIService.sharedInstance.fetchOperatingZoneLookup { (operationRegionArray, isCompleted) in
                if(isCompleted){
                    self.operatingRegionArray = operationRegionArray
                    self.removeActivityIndicatorView()
                }else{
                    self.removeActivityIndicatorView()
                }
            }
            self.removeActivityIndicatorView()
        }else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
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
        serviceTypeTextField.inputView = grievancePickerView
        operatingRegionTExtField.inputView = operatingRegionPickerView

        grievancePickerView.delegate = self
        grievancePickerView.dataSource = self
        operatingRegionPickerView.delegate = self
        operatingRegionPickerView.dataSource = self
       
    }
    
    
    @objc func donePressed(sender: UIBarButtonItem) {
       
        serviceTypeTextField.resignFirstResponder()
        operatingRegionTExtField.resignFirstResponder()
    }
    
    func setUpToolBar(){
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.rgb(red: 184, green: 41, blue: 37)
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(donePressed))
        toolBar.setItems([okBarBtn], animated: true)
        serviceTypeTextField.inputAccessoryView = toolBar
        operatingRegionTExtField.inputAccessoryView = toolBar
        
    }
    
  
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == grievancePickerView){
            if let array = self.grievanceTypeArray{
                return array.count
            }else{
                return 0
            }
        }else{
            if let array = self.operatingRegionArray{
                return array.count
            }else{
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(UserProfileDefaults.isEnglish){
            if(pickerView == grievancePickerView){
                if let array = self.grievanceTypeArray{
                    return array[row].NAME_EN
                }else{
                    return ""
                }
            }else {
                if let array = self.operatingRegionArray{
                    return array[row].NAME_EN
                }else{
                    return ""
                }
            }
        }else{
            if(pickerView == grievancePickerView){
                if let array = self.grievanceTypeArray{
                    return array[row].NAME_AR
                }else{
                    return ""
                }
            }else {
                if let array = self.operatingRegionArray{
                    return array[row].NAME_AR
                }else{
                    return ""
                }
            }
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(UserProfileDefaults.isEnglish){
            if(pickerView ==  grievancePickerView){
                if let array = self.grievanceTypeArray{
                    serviceTypeTextField.text = array[row].NAME_EN
                    if let id = array[row].ID{
                        grievanceId = id
                    }
                    
                }
            }else {
                if let array = self.operatingRegionArray{
                    operatingRegionTExtField.text = array[row].NAME_EN
                    if let id = array[row].ID{
                        operatingRegionId = id
                    }
                }
            }
        }else{
            if(pickerView ==  grievancePickerView){
                if let array = self.grievanceTypeArray{
                    serviceTypeTextField.text = array[row].NAME_AR
                    if let id = array[row].ID{
                        grievanceId = id
                    }
                    
                }
            }else {
                if let array = self.operatingRegionArray{
                    operatingRegionTExtField.text = array[row].NAME_AR
                    if let id = array[row].ID{
                        operatingRegionId = id
                    }
                }
            }
        }
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == serviceTypeTextField){
            if(serviceTypeTextField.text == ""){
                self.grievancePickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(grievancePickerView, didSelectRow: 0, inComponent: 0)
            }
            
        }else{
            if(operatingRegionTExtField.text == ""){
                self.operatingRegionPickerView.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(operatingRegionPickerView, didSelectRow: 0, inComponent: 0)
            }
            
        }

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
    
        addButton.isUserInteractionEnabled = false
        addButton.alpha = 0.5
        
        let comAndRem = CoplaintCategeoryAndRemarks()
        tableArray.append(comAndRem)
        
        let indPth:IndexPath = IndexPath(row: tableArray.count - 1, section: 0)
        complaintTableView.insertRows(at: [indPth], with: .right)
        complaintTableView.scrollToRow(at: indPth, at: .bottom, animated: true)
        
       
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GrievanceCell
        
        cell.toolBarFrameY = self.view.frame.size.height/6
        cell.toolBarFrameWidth =  self.view.frame.size.width
        cell.toolBarPositionX = self.view.frame.size.width/2
        cell.toolBarPositionY = self.view.frame.size.height-20.0
        cell.complaintCategoryTextField.tag = indexPath.row
        cell.remarksTextField.tag = indexPath.row
        cell.delegate = self
        
        cell.complaintCategoryTextField.text = ""
        cell.remarksTextField.text = ""
        
        if let text = cell.complaintCategoryTextField.text {
            if(text == ""){
                cell.complaintCategoryTextField.inputView = cell.complaintCategoryPickerView
                if(UserProfileDefaults.isEnglish){
                    
                    if let cat = tableArray[indexPath.row].complaintCategory{
                        cell.complaintCategoryTextField.text = cat.NAME_EN
                    }
                    
                }else{
                    if let cat = tableArray[indexPath.row].complaintCategory{
                        cell.complaintCategoryTextField.text = cat.NAME_AR
                    }
                }
            }
        }
        
         cell.remarksTextField.text = tableArray[indexPath.row].remarks
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
    func didEnterRemarks(remarks: String, rowNumber: Int) {
//        tableArray[rowIndexPath.row].remarks = remarks
//        let indPath = IndexPath(row: rowIndexPath.row, section: 0)
//        let cell = complaintTableView.cellForRow(at: indPath) as! GrievanceCell
//
//        cell.remarksTextField.text = tableArray[rowIndexPath.row].remarks
        //complaintTableView.reloadData()
        tableArray[rowNumber].remarks = remarks
        complaintTableView.reloadData()
        
    }
    
    func didSelectCategory(selectedCategory: GrievanceSubcategoryLookUp, rowNumber: Int) {
//        tableArray[rowIndexPath.row].complaintCategory = selectedCategory
//        print(rowIndexPath.row)
//        let indPath = IndexPath(row: rowIndexPath.row, section: 0)
//        let cell = complaintTableView.cellForRow(at: indPath) as! GrievanceCell
//        cell.complaintCategoryTextField.text = tableArray[rowIndexPath.row].complaintCategory?.NAME_EN
        
        tableArray[rowNumber].complaintCategory = selectedCategory
        addButton.isUserInteractionEnabled = true
        addButton.alpha = 1
        complaintTableView.reloadData()
    }
    
    func didSelectCategoryAndRemarks(selectedCategory: GrievanceSubcategoryLookUp, remarks: String, rowNumber: Int) {
        tableArray[rowNumber].complaintCategory = selectedCategory
        tableArray[rowNumber].remarks = remarks
        addButton.isUserInteractionEnabled = true
        addButton.alpha = 1
        complaintTableView.reloadData()
    }
    
    @IBAction func submitbuttonTapped(_ sender: UIButton) {
      
        if(Reachability.isConnectedToNetwork()){
            var complaintsArray: [[String:Any]]?
            complaintsArray = [[String:Any]]()
            var isDuplicated: Bool = false
            var counts: [String: Int] = [:]
            for tableItem in tableArray {
                var myDictOfDict = [String:Any]()
                if let item = tableItem.complaintCategory{
                    if let id = item.ID{
                        counts["\(id)"] = (counts["\(id)"] ?? 0) + 1
                        myDictOfDict = ["ComplaintSubCatId":id ,"Remarks":tableItem.remarks! as Any]
                    }
                }
                complaintsArray?.append(myDictOfDict)
            }
            print(counts)
            for (key, value) in counts {
                if(value > 1){
                    isDuplicated = true
                    break
                }else{
                    isDuplicated = false
                }
            }
            print(isDuplicated)
            //        if let id = complaintCategoryId{
            //                        var myDictOfDict = [String:Any]()
            //                        if let text = remarksTextField.text {
            //                            myDictOfDict = ["ComplaintSubCatId":id ,"Remarks":text as Any]
            //                        }
            //                        complaintsArray?.append(myDictOfDict)
            //                    }
            
            
            if(isDuplicated){
                self.present(Alert.createErrorAlert(title: "Message", message: "Same complaint category selected multiple times"), animated: true, completion: nil)
            }else{
                if let id = grievanceId,let oId = operatingRegionId, let cArray = complaintsArray{
                    setupActivityIndicator()
                    GrievanceTypeAndSubCategoryLookUpAPI.sharedInstance.submitGrievance(gId: id, oId: oId, dict: cArray, completion: { (isCompleted) in
                        if(isCompleted){
                            self.removeActivityIndicatorView()
                            //self.present(Alert.createErrorAlert(title: "Message", message: "Grievance submitted successfully"), animated: true, completion: nil)
                            self.removeValues()
                            complaintsArray = nil
                            let alert = UIAlertController(title: "Message", message: "Grievance submitted successfully", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }else{
                            self.removeActivityIndicatorView()
                            self.present(Alert.createErrorAlert(title: "Try again", message: "Something went wrong"), animated: true, completion: nil)
                            self.removeValues()
                            complaintsArray = nil
                        }
                    })
                }else{
                    self.removeValues()
                    self.removeActivityIndicatorView()
                    complaintsArray = nil
                    self.present(Alert.createErrorAlert(title: "Try again", message: "None of the fields should be empty"), animated: true, completion: nil)
                }
            }
        }else {
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        
        
        
    }
    
    func removeValues(){
        
        let complaintcategoryAndRemarsk =  CoplaintCategeoryAndRemarks()
        self.tableArray.removeAll()
        self.tableArray.append(complaintcategoryAndRemarsk)
        self.serviceTypeTextField.text = ""
        self.operatingRegionTExtField.text = ""
        grievanceId = nil
        operatingRegionId = nil
        complaintTableView.reloadData()
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

class CoplaintCategeoryAndRemarks {
    var complaintCategory: GrievanceSubcategoryLookUp?
    var remarks: String?
}


