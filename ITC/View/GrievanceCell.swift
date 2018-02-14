//
//  GrievanceCell.swift
//  ITC
//
//  Created by Harsha M G on 03/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit



protocol GrievanceCellDelegate {
    func didEnterRemarks(remarks:String, rowNumber: Int)
    func didSelectCategory(selectedCategory:GrievanceSubcategoryLookUp, rowNumber: Int )
    func didSelectCategoryAndRemarks(selectedCategory:GrievanceSubcategoryLookUp,remarks:String ,rowNumber: Int )
    
}

class GrievanceCell: UITableViewCell,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var complaintCategoryTextField: UITextField!
    @IBOutlet weak var remarksTextField: UITextField!
    let complaintCategoryPickerView = UIPickerView()
    var vw = UIView()
    @IBOutlet weak var categoryTextLabel: UILabel!
    @IBOutlet weak var remarksTextLabel: UILabel!
    var grievanceSubCategoryArray: [GrievanceSubcategoryLookUp]?
    var toolBarFrameY: CGFloat = 0.0
    var toolBarFrameWidth: CGFloat = 0.0
    var toolBarPositionX: CGFloat = 0.0
    var toolBarPositionY: CGFloat = 0.0
    
    var delegate: GrievanceCellDelegate?
    var catId: Int = 0
    var remrks: String = ""
    var grievanceSubCat: GrievanceSubcategoryLookUp?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        complaintCategoryTextField.delegate = self
        remarksTextField.delegate = self
        
        if(UserProfileDefaults.isEnglish){
            complaintCategoryTextField.placeholder = "Select category"
            remarksTextField.placeholder = "Type the remarks here"
            remarksTextLabel.text = "Remarks"
            categoryTextLabel.text = "Category"
        }else{
            complaintCategoryTextField.placeholder = "Select category"
            remarksTextField.placeholder = NSLocalizedString("Type the remarks here", comment: "")
            remarksTextLabel.text = NSLocalizedString("Remarks", comment: "")
            categoryTextLabel.text = NSLocalizedString("Category", comment: "")
            complaintCategoryTextField.placeholder = NSLocalizedString("Category", comment: "")
        }
        
        
        setUpToolBar()
        setUpPickerViews()
      
        GrievanceTypeAndSubCategoryLookUpAPI.sharedInstance.fetchGrievanceSubCategoryLookUps { (grievanceSubCatArray, isCompleted) in
            if(isCompleted){
                self.grievanceSubCategoryArray = grievanceSubCatArray
                self.complaintCategoryPickerView.reloadAllComponents()
            }else{
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
  
    
    func setUpPickerViews() {
        complaintCategoryTextField.inputView = complaintCategoryPickerView
        complaintCategoryPickerView.delegate = self
        complaintCategoryPickerView.dataSource = self
    }
    
    
    @objc func donePressed(sender: UIBarButtonItem) {
        complaintCategoryTextField.resignFirstResponder()
    }
    
    func setUpToolBar(){
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: toolBarFrameY, width: toolBarFrameWidth, height: 40))
        toolBar.layer.position = CGPoint(x: toolBarPositionX, y: toolBarPositionY)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.rgb(red: 184, green: 41, blue: 37)
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(donePressed))
        toolBar.setItems([okBarBtn], animated: true)
        complaintCategoryTextField.inputAccessoryView = toolBar
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if let del = delegate{
            
            if let obj = grievanceSubCat, let text = remarksTextField.text {
                if(text != ""){
                del.didSelectCategoryAndRemarks(selectedCategory: obj, remarks: text, rowNumber: remarksTextField.tag)
                }
            }
            
            
            
            
//        if let obj = grievanceSubCat {
//
//            del.didSelectCategory(selectedCategory: obj, rowNumber: complaintCategoryTextField.tag)
//        }
//            if let text = remarksTextField.text {
//                if(text != ""){
//                     del.didEnterRemarks(remarks: text, rowNumber: remarksTextField.tag)
//                }
//            }
       
        
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == complaintCategoryTextField){
            if(complaintCategoryTextField.text == ""){
                if (self.grievanceSubCategoryArray != nil) {
                    self.complaintCategoryPickerView.selectRow(0, inComponent: 0, animated: true)
                    self.pickerView(complaintCategoryPickerView.self, didSelectRow: 0, inComponent: 0)
                }
                
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let array = self.grievanceSubCategoryArray{
            return array.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(UserProfileDefaults.isEnglish){
            if let array = self.grievanceSubCategoryArray{
                return array[row].NAME_EN
            }else{
                return ""
            }
        }else{
            
            if let array = self.grievanceSubCategoryArray{
                return array[row].NAME_AR
            }else{
                return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(UserProfileDefaults.isEnglish){
            if let array = self.grievanceSubCategoryArray{
                grievanceSubCat = array[row]
                complaintCategoryTextField.text = array[row].NAME_EN
                if let id = array[row].ID{
                    catId = id
                    
                }
            }
        }else{
            if let array = self.grievanceSubCategoryArray{
                grievanceSubCat = array[row]
                complaintCategoryTextField.text = array[row].NAME_AR
                if let id = array[row].ID{
                   catId = id
                }
            }
        }
    }
    
}











