//
//  InvestigationController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class InvestigationController: UIViewController {

    @IBOutlet weak var bookInvestigationButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var carImageView: UIImageView!
    
    
    
    
    var vw = UIView()
    var violationArray : [BookInvestigation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Investigation"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Investigation", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        carImageView.frame.origin.y = self.view.frame.height
        bookInvestigationButton.frame.origin.x = -128
        scheduleButton.frame.origin.x = 323
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.carImageView.frame.origin.y = 16
            self.bookInvestigationButton.frame.origin.x = 8
            self.scheduleButton.frame.origin.x = (self.bookInvestigationButton.frame.origin.x) + (self.scheduleButton.frame.width * 2)
            
        }, completion:nil)
        
        if(UserProfileDefaults.isEnglish){
            bookInvestigationButton.setTitle(" Book", for: .normal)
            scheduleButton.setTitle("Schedule", for: .normal)
        }else{
           
            bookInvestigationButton.setTitle(NSLocalizedString("Book Investigation", comment: ""), for: .normal)
            scheduleButton.setTitle(NSLocalizedString("Investigation Schedule", comment: ""), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func bookInvestigationButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toBookInvesstigation", sender: self)
   }
    
    @IBAction func investigationScheduleTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toInvestigationSchedule", sender: self)
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
