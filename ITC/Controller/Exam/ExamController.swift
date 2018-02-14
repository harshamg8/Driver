//
//  ExamController.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ExamController: UIViewController {

    @IBOutlet weak var bookExamButton: UIButton!
    @IBOutlet weak var examResultButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var carImageView: UIImageView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Exam"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Exam", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        
         carImageView.frame.origin.y = self.view.frame.height
        bookExamButton.frame.origin.x = -128
        examResultButton.frame.origin.x = 323
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.carImageView.frame.origin.y = 16
            self.bookExamButton.frame.origin.x = 8
            self.examResultButton.frame.origin.x = (self.bookExamButton.frame.origin.x) + (self.examResultButton.frame.width * 2)
            
        }, completion:nil)
        
        
        
        if(UserProfileDefaults.isEnglish){
            
            bookExamButton.setTitle("Book Exam", for: .normal)
            examResultButton.setTitle("Exam Results", for: .normal)
        }else{
            
            bookExamButton.setTitle(NSLocalizedString("Book Exam", comment: ""), for: .normal)
            examResultButton.setTitle(NSLocalizedString("Exam Results", comment: ""), for: .normal)
        }
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookExamTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toServiceType", sender: self)
        
        
    }
    
    @IBAction func viewExamResultTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toExamResult", sender: self)
    }
   
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//
//    }
    

}
