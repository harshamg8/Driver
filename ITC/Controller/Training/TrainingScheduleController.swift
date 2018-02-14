//
//  TrainingScheduleController.swift
//  ITC
//
//  Created by Harsha M G on 18/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class TrainingScheduleController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var scheduleTaleView: UITableView!
    @IBOutlet weak var noRecordsFoundLabel: UILabel!
  
    
    var scheduleArray: [TrainingSchedule]?
    var vw = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Schedule"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Schedule", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        self.noRecordsFoundLabel.text = ""
        if(Reachability.isConnectedToNetwork()){
        setupActivityIndicator()
        TrainingAPI.sharedInstance.fetchTrainingSchedule{(scheduleArray, isCompleted) in
            if(isCompleted){
                self.scheduleArray = scheduleArray
                self.removeActivityIndicatorView()
                self.scheduleTaleView.reloadData()
                self.noRecordsFoundLabel.text = ""
            }else{
                self.removeActivityIndicatorView()
                 self.present(Alert.createErrorAlert(title: "Sorry", message: "No Record Found"), animated: true, completion: nil)
                self.noRecordsFoundLabel.text = "No Records Found"
                }
           
            }
        }else{
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = scheduleArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TrainingScheduleViewCell
        if let array = scheduleArray{
            cell.obj = array[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
