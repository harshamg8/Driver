//
//  ServiceTypeController.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ServiceTypeController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var serviceTypeTableView: UITableView!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!
    var serviceArray: [ServiceLookup]?
    var serviceType: Int?
    var levelArray: [Level]?
    var vw = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileIdLabel.text = Helper.getProfileIdBasedOnTheLanguage()
        permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()

        if(UserProfileDefaults.isEnglish){
            self.navigationItem.title = "Select Service Type"
        }else{
            self.navigationItem.title = "Select Service Type"
        }
        setupActivityIndicator()
        APIService.sharedInstance.fetchServiceLookup { (serviceArray, isCompleted) in
            if(isCompleted){
                self.serviceArray = serviceArray
                self.removeActivityIndicatorView()
                self.serviceTypeTableView.reloadData()
                self.noRecordFoundLabel.text = ""
            }else {
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "Sorry", message: "Service Type Not Available"), animated: true, completion: nil)
                self.noRecordFoundLabel.text = "No Records Found"
            }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.serviceArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ServiceCell
       
        if(indexPath.row % 2 == 0){
            cell.bottomView.frame.origin.x = cell.contentView.frame.width
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.bottomView.frame.origin.x = 8
                
            }, completion: nil)
        }else{
            cell.bottomView.frame.origin.y = self.view.frame.height
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.bottomView.frame.origin.y = 1
                
            }, completion: nil)
        }
        
        
        if(UserProfileDefaults.isEnglish){
            if let array = self.serviceArray{
                if let name = array[indexPath.row].NAME_EN{
                    cell.serviceTypeLabel.text = name
                }
            }
        }else{
            if let array = self.serviceArray{
                if let name = array[indexPath.row].NAME_AR{
                    cell.serviceTypeLabel.text = name
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let array = self.serviceArray{
            if let id = array[indexPath.row].ID {
                serviceType = id
                fetchLevels()
            }
        }
    }
    
    func fetchLevels(){
        
        if let type = serviceType  {
           setupActivityIndicator()
            APIService.sharedInstance.isEligibleForBookingExam(serviceType: String(type), completion: { (levelArray, isCompleted) in
                if(isCompleted){
                    self.levelArray = levelArray
                    if let array = self.levelArray {
                        if(array.count > 0){
                               self.removeActivityIndicatorView()
                            self.performSegue(withIdentifier: "toLevel", sender: self)
                            
                        }else{
                            
                           self.removeActivityIndicatorView()
                            self.present(Alert.createErrorAlert(title: "Sorry", message: "You are not eligible to take an exam under this service type"), animated: true, completion: nil)
                        }
                    }else{
                       self.removeActivityIndicatorView()
                        self.present(Alert.createErrorAlert(title: "Sorry", message:"You are not eligible to take an exam under this service type"), animated: true, completion: nil)
                    }
                }else{
                   self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message:"You are not eligible to take an exam under this service type"), animated: true, completion: nil)
                }
            })
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        let levelVC = segue.destination as! LevelsController
        levelVC.levelArray = self.levelArray
        if let type = self.serviceType {
            levelVC.serviceType = String(type)
        }
        
    }
    
}
