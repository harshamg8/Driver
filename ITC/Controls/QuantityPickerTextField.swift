//
//  QuantityPickerTextField.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

protocol QuantityPickerDelegate {
    func textField(_ textField: UITextField, quantity: Int)
}

class QuantityPickerTextField: UITextField, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var predefinedValue = 1
    
    var quantityPickerDelegate: QuantityPickerDelegate?
    
    var imageViewDropDown = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupControl()
    }
    
    func setupControl() {
        delegate = self
        text = String(predefinedValue)
        
        //Style for Textfield
        borderStyle = .line
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        tintColor = .clear
        textColor = .black
        textAlignment = .center
        
        // Setting dropdown image for control
        rightViewMode = .always
        
        let image = #imageLiteral(resourceName: "down").withRenderingMode(.alwaysTemplate)
        imageViewDropDown.tintColor = .black
        imageViewDropDown.image = image
        rightView = imageViewDropDown
        
        //Creating toolbar control for editing usability
        let barView = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 50))
        barView.isTranslucent = false
        
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(QuantityPickerTextField.btnDone_Tapped))
        let btnCancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(QuantityPickerTextField.btnCancel_Tapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barView.items = [btnDone, flexibleSpace, btnCancel]
        
        //Setting pickerVieww as input view
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        inputView = pickerView
        inputAccessoryView = barView
        
        barView.barTintColor = .lightGray
    }
    
    @objc func btnDone_Tapped() {
        endEditing(true)
        quantityPickerDelegate?.textField(self, quantity: Int(text!)!)
    }
    
    @objc func btnCancel_Tapped() {
        text = String(predefinedValue)
        endEditing(true)
    }
    
    // MARK: - UIPickerview Delegates and Datasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = String(row + 1)
    }
    
    // MARK: - UITextField Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        predefinedValue = Int(text!)!
        return true
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
