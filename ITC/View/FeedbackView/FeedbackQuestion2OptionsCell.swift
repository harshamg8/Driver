//
//  FeedbackQuestion2OptionsCell.swift
//  ITC
//
//  Created by Harsha M G on 12/02/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit
protocol FromSuggestionDelegate {
    func didFinishtypingSuggestion(text: String, freeTextQuestion: FeedbackQuestion)
}
class FeedbackQuestion2OptionsCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var questionlabel: UILabel!
    
    @IBOutlet weak var suggestionTextfield: UITextField!
    
    var delegate: FromSuggestionDelegate?
    
    var freeText: FeedbackQuestion? {
        didSet{
            if let obj = freeText?.Question{
                self.questionlabel.text = obj
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        suggestionTextfield.delegate = self
    }

    func eraseSugeestions(){
        suggestionTextfield.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let del = delegate{
            if let obj = freeText, let text = suggestionTextfield.text{
                if(text != ""){
                   del.didFinishtypingSuggestion(text: text, freeTextQuestion: obj)
                }
                
            }
            
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
