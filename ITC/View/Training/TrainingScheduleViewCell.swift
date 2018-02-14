//
//  TrainingScheduleViewCell.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class TrainingScheduleViewCell: UITableViewCell {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var chapterNameLabel: UILabel!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var courseCodeTextLabel: UILabel!
    @IBOutlet weak var scheduleDateTextLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    var obj: TrainingSchedule? {
        didSet{
            
            if(UserProfileDefaults.isEnglish){
                if let value = obj?.COURSE_NAME_EN {
                    courseNameLabel.text = value
                }else{
                    courseNameLabel.text = "-"
                }
                if let value = obj?.CHAPTER_NAME_EN {
                    if let code = obj?.CHAPTER_CODE {
                        chapterNameLabel.text = "\(code) - \(value)"
                    }else{
                        chapterNameLabel.text = value
                    }
                }else{
                    chapterNameLabel.text = "-"
                }
            }else{
                if let value = obj?.COURSE_NAME_AR {
                    courseNameLabel.text = value
                }else{
                    courseNameLabel.text = "-"
                }
                if let value = obj?.CHAPTER_NAME_AR {
                    if let code = obj?.CHAPTER_CODE {
                        chapterNameLabel.text = "\(code) - \(value)"
                    }else{
                        chapterNameLabel.text = value
                    }
                }else{
                    chapterNameLabel.text = "-"
                }
            }
           
          
            if let value = obj?.SCHEDULE_DATE {
                scheduleDateLabel.text = Helper.getCorrectDate(dateString: value)
            }else{
                scheduleDateLabel.text = "-"
            }
            if let value = obj?.COURSE_CODE {
                courseCodeLabel.text = String(value)
            }else{
                courseCodeLabel.text = "-"
            }
            
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(UserProfileDefaults.isEnglish){
           
            courseCodeTextLabel.text = "Course Code"
            scheduleDateTextLabel.text = "Scheduled Date"
        }else{
            
            courseCodeTextLabel.text = NSLocalizedString("Course code", comment: "")
            scheduleDateTextLabel.text = NSLocalizedString("Scheduled date", comment: "")
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
