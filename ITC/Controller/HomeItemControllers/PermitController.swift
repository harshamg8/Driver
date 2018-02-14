//
//  PermitController.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class PermitController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var renewHistoryButton: UIButton!
    @IBOutlet weak var suspensionHistoryButton: UIButton!
    @IBOutlet weak var horizontalView: UIView!
    
    
    var vw = UIView()
    var permitStatusArray: [Permit]?
    var permitRenewHistoryArray: [PermitRenewalHistory]?
    var permitSuspensionHistoryArray: [PermitSuspensionHistory]?
    
    @IBOutlet weak var cv: UICollectionView!
    var index: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Permit"
            statusButton.setTitle("Status", for: .normal)
            renewHistoryButton.setTitle("Renew History", for: .normal)
            suspensionHistoryButton.setTitle("Suspension History", for: .normal)
            
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Permit", comment: "")
            statusButton.setTitle(NSLocalizedString("Status", comment: ""), for: .normal)
            renewHistoryButton.setTitle(NSLocalizedString("Renew History", comment: ""), for: .normal)
            suspensionHistoryButton.setTitle(NSLocalizedString("Suspension History", comment: ""), for: .normal)
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        let renewhistory = UINib(nibName: "PermitRenewalHistoryView", bundle: nil)
        cv.register(renewhistory, forCellWithReuseIdentifier: "cellId2")
        
        let suspensionHistory = UINib(nibName: "PermitSuspensionHistoryView", bundle: nil)
        cv.register(suspensionHistory, forCellWithReuseIdentifier: "cellId3")
        
        let statusView = UINib(nibName: "PermitCardCell", bundle: nil)
        cv.register(statusView, forCellWithReuseIdentifier: "cellId1")
        
        if let flowLayout = cv?.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        
        if(Reachability.isConnectedToNetwork()){
            
            setupActivityIndicator()
            APIService.sharedInstance.fetchPermitDetails { (recievedArray, isCompleted) in
                if(isCompleted){
                    self.permitStatusArray = recievedArray
                    self.removeActivityIndicatorView()
                    self.cv.reloadData()
                }else{
                    //self.present(Alert.createErrorAlert(title: "Sorry", message: "No records found for permit status"), animated: true, completion: nil)
                    self.removeActivityIndicatorView()
                }
            }
            
            APIService.sharedInstance.fetchPermitRenewalHistory { (recievedArray, isCompleted) in
                if(isCompleted){
                    self.permitRenewHistoryArray = recievedArray
                    self.removeActivityIndicatorView()
                    self.cv.reloadData()
                }else{
                    //                self.present(Alert.createErrorAlert(title: "Sorry", message: "No records found for permit renew history"), animated: true, completion: nil)
                    self.removeActivityIndicatorView()
                }
            }
            
            APIService.sharedInstance.fetchPermitSuspensionHistory { (recievedArray, isCompleted) in
                if(isCompleted){
                    self.permitSuspensionHistoryArray = recievedArray
                    self.removeActivityIndicatorView()
                    self.cv.reloadData()
                }else{
                    //                self.present(Alert.createErrorAlert(title: "Sorry", message: "No records found for permit suspension history"), animated: true, completion: nil)
                    self.removeActivityIndicatorView()
                }
            }
            
        }else{
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
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item == 0){
            index = 0
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId1", for: indexPath) as! PermitCardCell
        
            if (self.permitStatusArray != nil){
               // cell.statusArray = array
            }
            return cell
        }
        
        else if(indexPath.item == 1){
            index = 1
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId2", for: indexPath) as! PermitRenewalHistoryView
            if let array = self.permitRenewHistoryArray{
                cell.renewhistoryArray = array
            }
            
            return cell
        }
        
        else{
            index = 2
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId3", for: indexPath) as! PermitSuspensionHistoryView
            if let array = self.permitSuspensionHistoryArray{
                cell.suspensionHistoryArray = array
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.cv.frame.width, height: self.cv.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        if(index == 0.0){
            
            changeTitleColour(redButton: statusButton, blackButton1: renewHistoryButton, blackbutton2: suspensionHistoryButton)
            
            scrollHorizontalView(value: 0)
            
            
            
        }else if(index == 1.0){
            changeTitleColour(redButton: renewHistoryButton, blackButton1: statusButton, blackbutton2: suspensionHistoryButton)
            scrollHorizontalView(value: self.statusButton.frame.width)
            
            
        }else{
            changeTitleColour(redButton: suspensionHistoryButton, blackButton1: statusButton, blackbutton2: renewHistoryButton)
            scrollHorizontalView(value: self.statusButton.frame.width * 2)
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if(sender == statusButton){
            scrollToIndex(index: 0)
            scrollHorizontalView(value: 0)
            changeTitleColour(redButton: statusButton, blackButton1: renewHistoryButton, blackbutton2: suspensionHistoryButton)
            
            self.cv.reloadData()
        }else if(sender == renewHistoryButton){
            scrollToIndex(index: 1)
            scrollHorizontalView(value: self.statusButton.frame.width)
            changeTitleColour(redButton: renewHistoryButton, blackButton1: statusButton, blackbutton2: suspensionHistoryButton)
            
            self.cv.reloadData()
        }else{
            scrollToIndex(index: 2)
            scrollHorizontalView(value: self.statusButton.frame.width * 2)
            changeTitleColour(redButton: suspensionHistoryButton, blackButton1: statusButton, blackbutton2: renewHistoryButton)
            self.cv.reloadData()
            
        }
    }
    
   
    
    func scrollToIndex(index: Int){
        let indexpath = IndexPath(item: index, section: 0)
        cv.scrollToItem(at: indexpath, at: .right, animated: true)
    }
    
    func scrollHorizontalView(value: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.horizontalView.frame.origin.x = value
        }, completion: nil)
    }
    
    func changeTitleColour(redButton: UIButton, blackButton1: UIButton, blackbutton2: UIButton){
        
        redButton.setTitleColor(UIColor.rgb(red: 184, green: 37, blue: 42), for: .normal)
        
        blackButton1.setTitleColor(UIColor.black, for: .normal)
        blackbutton2.setTitleColor(UIColor.black, for: .normal)
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
