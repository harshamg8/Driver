//
//  ExamResultCell.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ExamResultCell: UITableViewCell {

    @IBOutlet weak var examCenterLabel: UILabel!
    
    @IBOutlet weak var examTypeLabel: UILabel!
    
    @IBOutlet weak var examDateLabel: UILabel!
    
    @IBOutlet weak var marksLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var levelDescriptionLabel: UILabel!
    
    @IBOutlet weak var examCentertextLabel: UILabel!
    @IBOutlet weak var examDateTextLabel: UILabel!
    @IBOutlet weak var examtypeTextLabel: UILabel!
    @IBOutlet weak var marksTextLabel: UILabel!
    @IBOutlet weak var timeTextLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    
    
    var examResult: ExamResult? {
        didSet{
        
       
            
            if let examCenter = examResult?.ASSESSMENT_CENTER {
                examCenterLabel.text = examCenter
            }
            if(UserProfileDefaults.isEnglish){
                if let type = examResult?.SERVICE_TYPE_NAME {
                    examTypeLabel.text = type
                }
            }else{
                if let type = examResult?.SERVICE_TYPE_NAME_AR {
                    examTypeLabel.text = type
                }
            }
            
            if(UserProfileDefaults.isEnglish){
                if let desc = examResult?.LEVEL_DESCRION_EN {
                    levelDescriptionLabel.text = desc
                }
            }else{
                if let desc = examResult?.LEVEL_DESCRION_AR {
                    levelDescriptionLabel.text = desc
                }
            }

           
            if let examDate = examResult?.ASSESSMENT_DATE {
                examDateLabel.text = Helper.getCorrectDate(dateString: examDate)
                timeLabel.text = Helper.getCorrectTime(dateString: examDate)
            }
            if let marks = examResult?.ASSESSMENT_MARK {
                marksLabel.text = String(marks)
            }
            if let result = examResult?.IS_PASSED {
                if result == 1{
                    if(UserProfileDefaults.isEnglish){
                        resultLabel.text = "PASS"
                    }else{
                        resultLabel.text = "PASS"
                    }
                    
                    resultLabel.textColor = UIColor.rgb(red: 34, green: 136, blue: 34)
                }else{
                    if(UserProfileDefaults.isEnglish){
                        resultLabel.text = "FAIL"
                    }else{
                        resultLabel.text = "FAIL"
                    }
                    resultLabel.textColor = UIColor.rgb(red: 255, green: 0, blue: 0)
                }
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        bottomView.frame.origin.y = -self.contentView.frame.width
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomView.frame.origin.y = 1
            
        }, completion: nil)
        
        if(UserProfileDefaults.isEnglish){
            examCentertextLabel.text = "Exam Center"
            examtypeTextLabel.text = "Type"
            examDateTextLabel.text = "Date"
            marksTextLabel.text = "Marks"
            timeTextLabel.text = "Time"
        }else{
            examCentertextLabel.text = NSLocalizedString("Exam Centre", comment: "")
            examtypeTextLabel.text = NSLocalizedString("Exam Type", comment: "")
            examDateTextLabel.text = NSLocalizedString("Exam date", comment: "")
            marksTextLabel.text = NSLocalizedString("Marks", comment: "")
            timeTextLabel.text = NSLocalizedString("Time", comment: "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
