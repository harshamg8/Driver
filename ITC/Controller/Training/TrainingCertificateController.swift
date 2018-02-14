//
//  TrainingCertificateController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class TrainingCertificateController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var certificateTableView: UITableView!
    @IBOutlet weak var noRecordsFoundLabel: UILabel!
    
    
    
    
    var certificateArray: [TrainingCertificate]?
    var vw = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Certificates"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Certificates", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        certificateTableView.dataSource = self
        certificateTableView.delegate = self
        
        
        self.noRecordsFoundLabel.text = ""
        if(Reachability.isConnectedToNetwork()){
        setupActivityIndicator()
        TrainingAPI.sharedInstance.fetchTrainingCertificates { (certificateArray, isCompleted) in
            if(isCompleted){
                self.certificateArray = certificateArray
                self.certificateTableView.reloadData()
                self.removeActivityIndicatorView()
                self.noRecordsFoundLabel.text = ""
            }else{
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "Sorry", message: "No Record Found"), animated: true, completion: nil)
                self.noRecordsFoundLabel.text = "No Records Found"
                }
           
            
            }
        } else{
            noRecordsFoundLabel.text = "No Internet"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = certificateArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TrainingCertificateCell
        if let array = certificateArray{
            cell.obj = array[indexPath.row]
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
