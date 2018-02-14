//
//  VehicleRenewHistoryController.swift
//  ITC
//
//  Created by Harsha M G on 12/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class VehicleRenewHistoryController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var renewHistoryTable: UITableView!
    @IBOutlet weak var noRecorFoundLabel: UILabel!
    var vehicleRenewistoryArray: [VehicleRenewalHistory]?
    var vw = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "History"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("History", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        
        
        noRecorFoundLabel.text = ""
        if(Reachability.isConnectedToNetwork()){
        
        setupActivityIndicator()
        APIService.sharedInstance.checkVehicleRenewHistoryFromService { (vehicleRenewHistoryArray, isCompleted) in
            if(isCompleted){
                self.vehicleRenewistoryArray = vehicleRenewHistoryArray
                self.removeActivityIndicatorView()
                self.renewHistoryTable.reloadData()
                self.noRecorFoundLabel.text = ""
            }else{
                self.removeActivityIndicatorView()
                self.noRecorFoundLabel.text = "No Records found"
                self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records found"), animated: true, completion: nil)
            }
        }
        } else{
            noRecorFoundLabel.text = "No Internet"
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
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.vehicleRenewistoryArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CarRenewHistoryCell
        if let array = self.vehicleRenewistoryArray {
            cell.renewHistory = array[indexPath.row]
        }
        return cell
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
