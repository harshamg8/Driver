//
//  RequiredTrainingCell.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class RequiredTrainingCell: UITableViewCell {

    @IBOutlet weak var trainingSourceLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var suspensionLabel: UILabel!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var suspensionStatus: UILabel!
    
    @IBOutlet weak var trainingSourceTextLabel: UILabel!
    @IBOutlet weak var suspensionSDateTextLAbel: UILabel!
    @IBOutlet weak var courseCodeTextLabel: UILabel!
    @IBOutlet weak var suspensionStatusTextLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    
    
    var obj: REquiredTraining? {
        didSet{
            
            if(UserProfileDefaults.isEnglish){
                if let value = obj?.COURSE_NAME_EN {
                    courseNameLabel.text = value
                }else{
                    courseNameLabel.text = "-"
                }
                
                if let value = obj?.CHAPTER_NAME_EN {
                    if let code = obj?.CHAPTER_CODE{
                        chapterNameLabel.text = "\(code) - \(value)"
                    }else{
                        chapterNameLabel.text = value
                    }
                    
                }else{
                    chapterNameLabel.text = "-"
                }
                if let value = obj?.TRAINING_SOURCE_EN {
                    trainingSourceLabel.text = value
                }else{
                    trainingSourceLabel.text = "-"
                }
                
                
                
            }
            
            else{
                if let value = obj?.COURSE_NAME_AR {
                    courseNameLabel.text = value
                }else{
                    courseNameLabel.text = "-"
                }
                
                if let value = obj?.CHAPTER_NAME_AR {
                    chapterNameLabel.text = value
                }else{
                    chapterNameLabel.text = "-"
                }
                if let value = obj?.TRAINING_SOURCE_AR {
                    trainingSourceLabel.text = value
                }else{
                    trainingSourceLabel.text = "-"
                }
            }
            
            if let value = obj?.SUSPENSION_DATE {
                suspensionLabel.text = Helper.getCorrectDate(dateString: value)
            }else{
                suspensionLabel.text = "-"
            }
           
            if let code = obj?.COURSE_CODE{
                courseCodeLabel.text = String(code)
            }else{
                courseCodeLabel.text = "-"
            }
            if let isSuspended = obj?.IS_SUSPENDED{
                if(isSuspended == 1){
                    suspensionStatus.text = "Suspended"
                }else{
                    
                }
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(UserProfileDefaults.isEnglish){
            
            trainingSourceTextLabel.text = "Source"
            suspensionSDateTextLAbel.text = "Suspension Date"
            courseCodeTextLabel.text = "Course Code"
            suspensionStatusTextLabel.text = "Suspension Status"
        }else{
            
            trainingSourceTextLabel.text = NSLocalizedString("Training Source", comment: "")
            suspensionSDateTextLAbel.text = NSLocalizedString("Suspension Date", comment: "")
            courseCodeTextLabel.text = NSLocalizedString("Course code", comment: "")
            suspensionStatusTextLabel.text = NSLocalizedString("Suspension Status", comment: "")
        }
        
        bottomView.frame.origin.y = -self.contentView.frame.width
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomView.frame.origin.y = 1
            
        }, completion: nil)
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
