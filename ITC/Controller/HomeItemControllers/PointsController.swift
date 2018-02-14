//
//  PointsController.swift
//  ITC
//
//  Created by Harsha M G on 15/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class PointsController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var whitePointView: UIView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var circularProgressView: CircleProgressView!
    @IBOutlet weak var maximumPointslabel: UILabel!
    @IBOutlet weak var blackPointsTextLabel: UILabel!
    @IBOutlet weak var remainingPoints: UILabel!
    
    
    
    var whitePointsArray: [WhitePoint]?
    var blackPointsArray: [BlackPoint]?
    var whitePointsAr = "نقاط بيضاء"
    var blackPointsEr = "نقاط سوداء"
    @IBOutlet weak var blackPointView: UIView!
    var vw = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blackPointView.isHidden = true
        whitePointView.isHidden = true
       
        setupActivityIndicator()
        APIService.sharedInstance.fetchWhitepoints { (whitePointArray,isCompleted) in
            if(isCompleted){
                self.whitePointsArray = whitePointArray
                self.removeActivityIndicatorView()
                self.whitePointView.isHidden = false
                self.conigureImageViews()
            }else{
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "Message", message: "No Records Found"), animated: true, completion: nil)
            }
            
            
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
    
    
    
 
    func setupBlackPointView(){
        if let array =  self.blackPointsArray {
            if let max = array[0].MAX_BLACK_POINTS, let points = array[0].BLACK_POINTS {
                if(UserProfileDefaults.isEnglish){
                    maximumPointslabel.text = "Total Maximum Poins = \(max)"
                    blackPointsTextLabel.text = "Black Points = \(points)"
                    remainingPoints.text = "Remaining Points = \(max - points)"
                }else{
                   
                    let mpoints = NSLocalizedString("Total Maximum Points" , comment: "")
                    maximumPointslabel.text = "\(mpoints) = \(max)"
                    let bpoints = NSLocalizedString("Black points" , comment: "")
                    blackPointsTextLabel.text = "\(bpoints) = \(points)"
                    let rPoints = NSLocalizedString("Remaining Points", comment: "")
                    remainingPoints.text = "\(rPoints) = \(max - points)"
                }
                let nf = NumberFormatter()
                nf.numberStyle = NumberFormatter.Style.decimal
                nf.maximumFractionDigits = 2
                let a: Double = Double(points)/Double(max)
                self.circularProgressView.progress = 0
                UIView.animate(withDuration: 3, animations: {
                    self.circularProgressView.progress = a
                })
                
              
                
            }
            
        }
    }
    
    func conigureImageViews() {
        
        if let array = self.whitePointsArray{
            if let wh = array[0].WHITE_POINTS{
                if wh == 0 {
                    
                }else if wh == 1{
                    image1.image = UIImage(named: "starFilled")
                    
                }else if wh == 2{
                    image1.image = UIImage(named: "starFilled")
                    image2.image = UIImage(named: "starFilled")
                    
                }else if wh == 3{
                    image1.image = UIImage(named: "starFilled")
                    image2.image = UIImage(named: "starFilled")
                    image3.image = UIImage(named: "starFilled")
                }else if wh == 4{
                    image1.image = UIImage(named: "starFilled")
                    image2.image = UIImage(named: "starFilled")
                    image3.image = UIImage(named: "starFilled")
                    image4.image = UIImage(named: "starFilled")
                    
                }else{
                    image1.image = UIImage(named: "starFilled")
                    image2.image = UIImage(named: "starFilled")
                    image3.image = UIImage(named: "starFilled")
                    image4.image = UIImage(named: "starFilled")
                    image5.image = UIImage(named: "starFilled")
                    
                }
            }
        }else{
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //@IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
//        if pointSegmntedControl.selectedSegmentIndex == 0 {
//            blackPointView.isHidden = true
//            whitePointView.isHidden = false
//        }else{
//            blackPointView.isHidden = false
//            whitePointView.isHidden = true
//            APIService.sharedInstance.fetchBlackpoints { (blackPointsArray,isCompleted) in
//                if(isCompleted){
//
//                    self.blackPointsArray = blackPointsArray
//                    self.setupBlackPointView()
//                }else{
//                    self.present(Alert.createErrorAlert(title: "Message", message: "No Records Found"), animated: true, completion: nil)
//                }
//
//            }
//        }
        
    //}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
