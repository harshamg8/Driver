//
//  BookInvestigationController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class BookInvestigationController: UIViewController,UITableViewDelegate,UITableViewDataSource,CheckBookButtonClicked {
   
    var vw = UIView()
    var violationArray : [BookInvestigation]?
    var transactionId: Int?
    
    @IBOutlet weak var bookInvestigationTableIew: UITableView!
    @IBOutlet weak var noRecordsFoundLabel: UILabel!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        bookInvestigationTableIew.delegate = self
        bookInvestigationTableIew.dataSource = self
        self.noRecordsFoundLabel.text = ""
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            InvestigationAPI.sharedInstance.getViolationsWithInvestigation { (violationArray, isCompleted) in
                if(isCompleted){
                    self.violationArray = violationArray
                    print(violationArray)
                    self.bookInvestigationTableIew.reloadData()
                    self.removeActivityIndicatorView()
                    self.noRecordsFoundLabel.text = ""
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records Found"), animated: true, completion: nil)
                    self.noRecordsFoundLabel.text = "No Records Found"
                    
                }
            }
        }else{
            self.noRecordsFoundLabel.text = "No Internet"
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        
        
      
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Book Investigation"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Book Investigation", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView

        // Do any additional setup after loading the view.
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.violationArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookInvestigationCell
        if let array = self.violationArray {
            cell.violation = array[indexPath.row]
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 247
    }
    
    func didClickBookButton(violation: BookInvestigation, forCell cell: BookInvestigationCell) {
        if let type = violation.TRANS_ID {
            self.transactionId = type
            self.performSegue(withIdentifier: "toselect", sender: self)
        }else{
            self.present(Alert.createErrorAlert(title: "Sorrry", message: "Transaction Id not available"), animated: true, completion: nil)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! SelectDateAndTimeInvestigationController
        if let type = transactionId {
            vc.transtype = String(type)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
