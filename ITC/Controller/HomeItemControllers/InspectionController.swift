//
//  InspectionController.swift
//  ITC
//
//  Created by Harsha M G on 17/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class InspectionController: UIViewController {

    @IBOutlet weak var vehicleInspectionDateLabel: UILabel!
    @IBOutlet weak var nextInspectionTextLabel: UILabel!
    @IBOutlet weak var driverispectionLabel: UILabel!
    @IBOutlet weak var vehicleTextLabel: UILabel!
    @IBOutlet weak var driverTextLabel: UILabel!
    
    @IBOutlet weak var driverActualDateLabel: UILabel!
    @IBOutlet weak var vehicleActualdateLabel: UILabel!
    @IBOutlet weak var driverActualTimeLabel: UILabel!
    @IBOutlet weak var vehicleActualTimeLabel: UILabel!
    
    
    
    var isDriverLabel: Bool = true
    var timeEnd1 = Date()
    var timeEnd2 = Date()

    var inspectionArray: [Inspection]?
    var vw = UIView()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Quality Inspection"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Inspection", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        
        if(UserProfileDefaults.isEnglish){
            
            nextInspectionTextLabel.text = "Next Inspection Date"
            vehicleTextLabel.text = "Vehicle"
            driverTextLabel.text = "Driver"
        }else{
            
            nextInspectionTextLabel.text = NSLocalizedString("Next Inspection Date", comment: "")
            vehicleTextLabel.text = NSLocalizedString("Vehicle", comment: "")
            driverTextLabel.text = NSLocalizedString("Driver", comment: "")
        }
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            APIService.sharedInstance.checkVehicleQualityInspectionTime { (inspectionArray, isCompleted) in
                if(isCompleted){
                    self.inspectionArray = inspectionArray
                    self.removeActivityIndicatorView()
                    if let array = self.inspectionArray {
                        if let d =  array[0].VEH_INSPECTION_TIME {
                            self.updateView1(timeEndString: d)
                            self.vehicleActualdateLabel.text = Helper.getCorrectDate(dateString: d)
                            self.vehicleActualTimeLabel.text = Helper.getCorrectTime(dateString: d)
                        }else{
                            self.updateView1(timeEndString: "00-00-0000T00:00:00")
                        }
                        if let d = array[0].DRV_INSPECTION_TIME {
                            self.updateView2(timeEndString: d)
                            self.driverActualDateLabel.text = Helper.getCorrectDate(dateString: d)
                            self.driverActualTimeLabel.text = Helper.getCorrectTime(dateString: d)
                        }else{
                            self.updateView2(timeEndString: "00-00-0000T00:00:00")
                        }
                    }
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "No Record Found"), animated: true, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func updateView1(timeEndString: String) {
        // Initialize Label
        
        
        
        timeEnd1 = getDate(dateString: getCorrectDate(dateString: timeEndString))
        setTimeLeft1()
        
        // Start timer
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setTimeLeft1), userInfo: nil, repeats: true)
    }
    
    func updateView2(timeEndString: String) {
        // Initialize Label
        
        
        
        timeEnd2 = getDate(dateString: getCorrectDate(dateString: timeEndString))
        setTimeLeft2()
        
        // Start timer
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.setTimeLeft2), userInfo: nil, repeats: true)
    }
    
    
    @objc func setTimeLeft1() {
        let timeNow = Date()
        
        // Only keep counting if timeEnd is bigger than timeNow
        if timeEnd1.compare(timeNow as Date) == ComparisonResult.orderedDescending {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: timeNow , to: timeEnd1)
            
            
            //calendar.components([.day, .hour, .minute, .second], fromDate: timeNow, toDate: timeEnd, options: [])
            
            var dayText = String()
            var hourText = String()
            var minuteText = String()
            var secondsText = String()
            
            if let d = components.day, let x = components.hour, let y = components.minute, let z = components.second {
                dayText = "\(d)d "
                hourText = "\(x)h "
                minuteText = "\(y)"
                secondsText = "\(z)"
            }
            
            // Hide day and hour if they are zero
            if components.day! <= 0 {
                dayText = ""
                if components.hour! <= 0 {
                    hourText = ""
                }
            }
            driverispectionLabel.text = dayText + hourText + minuteText + "m " + secondsText + "s"

        }else{
            driverispectionLabel.text = "00d 00h 00m 00s"
        }
    }
    
    
    @objc func setTimeLeft2() {
        let timeNow = Date()
        
        // Only keep counting if timeEnd is bigger than timeNow
        if timeEnd2.compare(timeNow as Date) == ComparisonResult.orderedDescending {
            let calendar = NSCalendar.current
            let components = calendar.dateComponents([.day, .hour, .minute, .second], from: timeNow , to: timeEnd2)
            
            
            //calendar.components([.day, .hour, .minute, .second], fromDate: timeNow, toDate: timeEnd, options: [])
            
            var dayText = String()
            var hourText = String()
            var minuteText = String()
            var secondsText = String()
            
            if let d = components.day, let x = components.hour, let y = components.minute, let z = components.second {
                dayText = "\(d)d "
                hourText = "\(x)h "
                minuteText = "\(y)"
                secondsText = "\(z)"
            }
            
            // Hide day and hour if they are zero
            if components.day! <= 0 {
                dayText = ""
                if components.hour! <= 0 {
                    hourText = ""
                }
            }
            vehicleInspectionDateLabel.text = dayText + hourText + minuteText + "m " + secondsText + "s"
            
        }else{
            vehicleInspectionDateLabel.text = "00d 00h 00m 00s"
        }
    }
    
    
    
    
    
    
    
     func getCorrectDate(dateString: String) -> String {
        
        var dateStringComponents = dateString.components(separatedBy: ".")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let datefromString = formatter.date(from: dateStringComponents[0])
        if let value = datefromString {
            formatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss"
            return formatter.string(from: value)
        }else{
            return dateStringComponents[0]
        }
        
    }
    
    func getDate(dateString: String)-> Date{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss"
        
        if let a = formatter.date(from: dateString){
            return a
        }
        return Date()
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
