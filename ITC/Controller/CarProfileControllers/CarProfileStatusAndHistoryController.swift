//
//  CarProfileStatusAndHistoryController.swift
//  ITC
//
//  Created by Harsha M G on 17/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class CarProfileStatusAndHistoryController: UIViewController {

    var vw = UIView()
    
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var operatingRegion: UILabel!
    @IBOutlet weak var stickerNumber: UILabel!
    @IBOutlet weak var makeAndModel: UILabel!
    @IBOutlet weak var chasisNumber: UILabel!
    @IBOutlet weak var vehicleExpiryDate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var fueltypeLabel: UILabel!
    @IBOutlet weak var seatCount: UILabel!
    @IBOutlet weak var engineNumber: UILabel!
    @IBOutlet weak var additionalRegion: UILabel!
    

    @IBOutlet weak var numberTextLabel: UILabel!
    @IBOutlet weak var operatingRegionTextLabel: UILabel!
    @IBOutlet weak var stickerNumberTextLabel: UILabel!
    @IBOutlet weak var makeAndModelTextLabel: UILabel!
    @IBOutlet weak var chasisNumberTextLabel: UILabel!
    @IBOutlet weak var expiryDate2TextLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var fuelTypeTextLabel: UILabel!
    @IBOutlet weak var seatCountTextLabel: UILabel!
    @IBOutlet weak var engineNumberTextCount: UILabel!
    @IBOutlet weak var additionalRegionTextLabel: UILabel!
    

    
    
    var make = ""
    var model = ""
    var makeAndModelText = ""
    var vehicleStatusArray: [VehicleStatus]?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Car Profile"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Car Profile", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        
        
        if(UserProfileDefaults.isEnglish){
            
            numberTextLabel.text = "Taxi Number"
            operatingRegionTextLabel.text = "Operating Region"
            stickerNumberTextLabel.text = "Sticker Number"
            makeAndModelTextLabel.text = "Make & Model"
            chasisNumberTextLabel.text = "Chasis Number"
            expiryDate2TextLabel.text = "Expiry date"
            statusTextLabel.text = "Status"
            fuelTypeTextLabel.text = "Fuel Type"
            seatCountTextLabel.text = "Seat Count"
            engineNumberTextCount.text = "Engine Number"
            additionalRegionTextLabel.text = "Additional Region"
            
            
        }else{
           
            numberTextLabel.text = NSLocalizedString("Number", comment: "")
            operatingRegionTextLabel.text = NSLocalizedString("Operating Region", comment: "")
            stickerNumberTextLabel.text = NSLocalizedString("Sticker Number", comment: "")
            makeAndModelTextLabel.text = NSLocalizedString("Make & Model", comment: "")
            chasisNumberTextLabel.text = NSLocalizedString("Chasis Number", comment: "")
            expiryDate2TextLabel.text = NSLocalizedString("Expiry date", comment: "")
            statusTextLabel.text = NSLocalizedString("Status", comment: "")
            fuelTypeTextLabel.text = NSLocalizedString("Fuel Type", comment: "")
            seatCountTextLabel.text = NSLocalizedString("Seat Count", comment: "")
            engineNumberTextCount.text = NSLocalizedString("Engine Number", comment: "")
            additionalRegionTextLabel.text = NSLocalizedString("Additional Region", comment: "")
      
       
        }
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            APIService.sharedInstance.fetchVehicleStatus { (vehicleStatusArray, isCompleted) in
                if(isCompleted){
                    self.vehicleStatusArray = vehicleStatusArray
                    self.removeActivityIndicatorView()
                    self.setupVehicleStatusLabels()
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records Found for Vehicle Status"), animated: true, completion: nil)
                    
                }
            }
        }else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        
        

    }
    
    func setupVehicleStatusLabels(){
        if let array = vehicleStatusArray {
            let vechicleStat = array[0]
            if let numb = vechicleStat.TAXI_NUMBER {
                number.text = String(numb)
            }else{
                number.text = "-"
            }
            if let region = vechicleStat.OPERATING_REGION{
                operatingRegion.text = region
            }else{
                operatingRegion.text = "-"
            }
            if let sticker = vechicleStat.STICKER_NO{
                stickerNumber.text = String(sticker)
            }else{
                stickerNumber.text = "-"
            }
            if let region = vechicleStat.MAKE{
                make = region
            }else{
                make = ""
            }
            if let region = vechicleStat.MODEL{
                model = region
            }else{
                model = ""
            }
            makeAndModel.text = "\(make) - \(model)"
            if let region = vechicleStat.CHASSIS_NO{
                chasisNumber.text = region
            }else{
                chasisNumber.text = "-"
            }
            if let region = vechicleStat.EXPIRY_DATE{
                vehicleExpiryDate.text = Helper.getCorrectDate(dateString: region)
            }else{
                vehicleExpiryDate.text = "-"
            }
            if let region = vechicleStat.VEHICLE_STATUS{
                status.text = region
            }else{
                status.text = "-"
            }
            if let region = vechicleStat.FUEL_TYPE{
                fueltypeLabel.text = region
            }else{
                fueltypeLabel.text = "-"
            }
            if let region = vechicleStat.SEAT_COUNT{
                seatCount.text = "\(region)"
            }else{
                seatCount.text = "-"
            }
            if let region = vechicleStat.ENGINE_NO{
                engineNumber.text = region
            }else{
                engineNumber.text = "-"
            }
            if let region = vechicleStat.ADDITIONAL_REGION{
                additionalRegion.text = region
            }else{
                additionalRegion.text = "-"
            }
            
            
        }else{
            self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records Found for Vehicle Status"), animated: true, completion: nil)
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
    }
    

  

}
