//
//  MobileNumberCell.swift
//  ITC
//
//  Created by Harsha M G on 09/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

protocol MobileNumberCellDelegate {
    func didClickEditButton(mobilenumberCell: MobileNumberCell, mobileNumber: String)
}

class MobileNumberCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var delegate: MobileNumberCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.tag = 0
        if(UserProfileDefaults.isEnglish){
            editButton.setTitle("EDIT", for: .normal)
            cancelButton.setTitle("CANCEL", for: .normal)
        }else{
             editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
            cancelButton.setTitle(NSLocalizedString("CANCEL", comment: ""), for: .normal)
        }
        
        mobileNumberTextField.keyboardType = .numberPad
        mobileNumberTextField.borderStyle = .none
        mobileNumberTextField.isUserInteractionEnabled = false
        cancelButton.isHidden = true
        mobileNumberTextField.delegate = self
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = mobileNumberTextField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancelButton.isHidden = true
        if(UserProfileDefaults.isEnglish){
            editButton.setTitle("EDIT", for: .normal)
            mobileNumberTextField.borderStyle = .none
            mobileNumberTextField.isUserInteractionEnabled = false
            cancelButton.setTitle("CANCEL", for: .normal)
            editButton.tag = 0
        }else{
            editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
            mobileNumberTextField.borderStyle = .none
            mobileNumberTextField.isUserInteractionEnabled = false
            cancelButton.setTitle(NSLocalizedString("CANCEL", comment: ""), for: .normal)
            editButton.tag = 0
        }
        
    }
    
    
    
    
    
    @IBAction func editbuttonTapped(_ sender: UIButton) {
       
        if(editButton.tag == 0){
            cancelButton.isHidden = false
            if(UserProfileDefaults.isEnglish){
                editButton.setTitle("SAVE", for: .normal)
                mobileNumberTextField.borderStyle = .roundedRect
               
                mobileNumberTextField.isUserInteractionEnabled = true
                editButton.tag = 1
            }else{
                editButton.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)
                mobileNumberTextField.borderStyle = .roundedRect
                mobileNumberTextField.isUserInteractionEnabled = true
                editButton.tag = 1
            }
            
        }else{
            cancelButton.isHidden = true
            if(UserProfileDefaults.isEnglish){
                editButton.setTitle("EDIT", for: .normal)
                mobileNumberTextField.borderStyle = .none
                mobileNumberTextField.isUserInteractionEnabled = false
                delegate?.didClickEditButton(mobilenumberCell: self, mobileNumber: mobileNumberTextField.text!)
                editButton.tag = 0
            }else{
                editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
                mobileNumberTextField.borderStyle = .none
                mobileNumberTextField.isUserInteractionEnabled = false
                delegate?.didClickEditButton(mobilenumberCell: self, mobileNumber: mobileNumberTextField.text!)
                editButton.tag = 0
            }
            
        }
 
        
    }
    

}
