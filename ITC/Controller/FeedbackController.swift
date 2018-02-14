//
//  FeedbackController.swift
//  ITC
//
//  Created by Harsha M G on 17/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackController: UIViewController, SegmentedControlClicked, FromFeedbackquestionViewDelegate {
    
   
    var vw = UIView()
    var driverArray: [[String]]?
    
    @IBOutlet weak var scrollVw: UIScrollView!
    
  
    @IBOutlet weak var drivernameLabel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!

    
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var permitNumberTextLabel: UILabel!
    
    @IBOutlet weak var driverDetailsLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let switchView = UINib(nibName: "SwitchView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SwitchView
        switchView.delegate = self
        scrollVw.layer.cornerRadius = 10
        scrollVw.layer.masksToBounds = true
        
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Feedback"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Feedback", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        navigationItem.titleView = titleView
    
        
        if(Reachability.isConnectedToNetwork()){
            APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
                if(isCompleted){
                    self.driverArray = driverArray
                    if(UserProfileDefaults.isEnglish){
                        if let array = self.driverArray{
                            self.drivernameLabel.text = array[2][0]
                        }
                    }else{
                        if let array = DriverDetailsUserDefault.driverDetails{
                            self.drivernameLabel.text = array[2][0]
                        }
                        
                    }
                    self.removeActivityIndicatorView()
                    
                    if let array = self.driverArray{
                        self.permitNumberLabel.text = array[1][0]
                        
                    }
                    
                    
                }else{
                    self.removeActivityIndicatorView()
                }
                
                
            }
        } else{
             self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
    

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
    
    
    
    
    
    
    
 override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Feedback"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Feedback", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        let feedBackView = UINib(nibName: "FeedbackQuestionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FeedbackQuestionView
        
        feedBackView.delegate = self
        feedBackView.layer.cornerRadius = 10
        feedBackView.layer.masksToBounds =  true
        
        self.scrollVw.contentSize = CGSize.init(width: self.scrollVw.frame.width, height: feedBackView.frame.height)
        self.scrollVw.addSubview(feedBackView)
        feedBackView.frame = CGRect.init(x: 8, y: 0, width: scrollVw.frame.width - 16, height: feedBackView.frame.height)
        
        setupActivityIndicator()
        
        if(UserProfileDefaults.isEnglish){
            
            nameTextLabel.text = "Name"
            permitNumberTextLabel.text = "Permit Number"
            
            driverDetailsLabel.text = "Driver Details"
            self.tabBarItem.title = "Feedback"
            
            if(Reachability.isConnectedToNetwork()){
            APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
                if(isCompleted){
                    self.driverArray = driverArray
                    self.removeActivityIndicatorView()
                    if(UserProfileDefaults.isEnglish){
                        if let array = self.driverArray{
                            self.drivernameLabel.text = array[2][0]
                        }
                    }else{
                        if let array = DriverDetailsUserDefault.driverDetails{
                            self.drivernameLabel.text = array[2][0]
                        }
                        
                    }
                    
                    if let array = self.driverArray{
                        self.permitNumberLabel.text = array[1][0]
                        
                    }
                    
                }else{
                    self.removeActivityIndicatorView()
                }
            }
               
            } else{
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
            }
            
            
        }
        else{
            
            self.tabBarItem.title = NSLocalizedString("Feedback", comment: "")
            
            nameTextLabel.text = NSLocalizedString("Name", comment: "")
            permitNumberTextLabel.text = NSLocalizedString("Permit number", comment: "")
           
            driverDetailsLabel.text = NSLocalizedString("Driver Details", comment: "")
            
            if(Reachability.isConnectedToNetwork()){
            self.removeActivityIndicatorView()
            APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
                if(isCompleted){
                    self.driverArray = driverArray
                    self.removeActivityIndicatorView()
                    if(UserProfileDefaults.isEnglish){
                        if let array = self.driverArray{
                            self.drivernameLabel.text = array[2][0]
                        }
                        
                    }else{
                        if let array = DriverDetailsUserDefault.driverDetails{
                            self.drivernameLabel.text = array[2][0]
                        }
                        
                    }
                    
                    if let array = self.driverArray{
                        self.permitNumberLabel.text = array[1][0]
                        
                    }
                    
                }else{
                    self.removeActivityIndicatorView()
                }
                
            }
            } else{
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        }
    }
    
    func didFetchQuestionsAndOptions(didfetch: Bool) {
        if(didfetch){
            removeActivityIndicatorView()
        }
    }
    
    func didtapOnSubmit(feedbackArray: [[String : Any]], isDone: Bool) {
        if(Reachability.isConnectedToNetwork()){
            if(isDone){
                setupActivityIndicator()
                APIService.sharedInstance.submitfeedback(feedbackArray: feedbackArray, completion: { (isCompleted, message) in
                    if(isCompleted){
                        self.removeActivityIndicatorView()
                        self.present(Alert.createErrorAlert(title: "Message", message: message), animated: true, completion: nil)
                        
                        self.removeActivityIndicatorView()
                        self.present(Alert.createErrorAlert(title: "Sorry", message: message), animated: true, completion: nil)
                    }
                })
            }else{
                self.present(Alert.createErrorAlert(title: "Message", message: "Please answer the questions"), animated: true, completion: nil)
            }
            
            
            
        }else{
            removeActivityIndicatorView()
            present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func didSegmetedControlTapped(isEnglishSelected: Bool, object: SwitchView) {
        if(isEnglishSelected){
           
            nameTextLabel.text = "Name"
            permitNumberTextLabel.text = "Permit Number"
            
            driverDetailsLabel.text = "Driver Details"
            self.navigationItem.title = "Feedback"
            self.tabBarItem.title = "Feedback"
           
            if(Reachability.isConnectedToNetwork()){
            APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
                if(isCompleted){
                    self.driverArray = driverArray
                    if(UserProfileDefaults.isEnglish){
                        if let array = self.driverArray{
                            self.drivernameLabel.text = array[2][0]
                        }
                        
                    }else{
                        if let array = DriverDetailsUserDefault.driverDetails{
                            self.drivernameLabel.text = array[2][0]
                        }
                        
                    }
                    
                    if let array = self.driverArray{
                        self.permitNumberLabel.text = array[1][0]
                        
                    }
                    
                }
            }
        } else{
                self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
            
            
        }
            else{
            self.navigationItem.title = NSLocalizedString("Feedback", comment: "")
            self.tabBarItem.title = NSLocalizedString("Feedback", comment: "")
            
            nameTextLabel.text = NSLocalizedString("Name", comment: "")
            permitNumberTextLabel.text = NSLocalizedString("Permit number", comment: "")
          
            driverDetailsLabel.text = NSLocalizedString("Driver Details", comment: "")
            
            if(Reachability.isConnectedToNetwork()){
            APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
                if(isCompleted){
                    self.driverArray = driverArray
                    if(UserProfileDefaults.isEnglish){
                        self.drivernameLabel.text = driverArray[2][0]
                    }else{
                        if let array = DriverDetailsUserDefault.driverDetails{
                            self.drivernameLabel.text = array[2][0]
                        }
                        
                    }
                    
                    if let array = self.driverArray{
                        self.permitNumberLabel.text = array[1][0]
                        
                    }
                    
                }
            
            }
        } else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
    }
    
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
