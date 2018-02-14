//
//  PointsViewController.swift
//  ITC
//
//  Created by Harsha M G on 29/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit
import PieCharts

class PointsViewController: UIViewController,PieChartDelegate{
   
    func onSelected(slice: PieSlice, selected: Bool) {
        
    }
    

    @IBOutlet weak var totalPointsTextLAbel: UILabel!
    @IBOutlet weak var blackPointsTextLabel: UILabel!
    @IBOutlet weak var remainingPointsTextLabel: UILabel!
    @IBOutlet weak var blackPointsLabel: UILabel!
    @IBOutlet weak var circularProgressView: CircleProgressView!
    @IBOutlet weak var remainigPoints: UILabel!
    @IBOutlet weak var chartView: PieChart!
    
    @IBOutlet weak var exceedingBlackPoint: UILabel!
    
    var blackPointsArray: [BlackPoint]?
   var vw = UIView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView

        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Black Points"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Black points", comment: "")
        }

       titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
      circularProgressView.isHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartView.layers = [createCustomViewsLayer(), createTextLayer()]
        chartView.delegate = self
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            APIService.sharedInstance.fetchBlackpoints { (blackPointsArray,isCompleted) in
                if(isCompleted){
                    
                    self.blackPointsArray = blackPointsArray
                    self.removeActivityIndicatorView()
                    self.setUpBlackPoints()
                    if let array = self.blackPointsArray {
                        if(array.count > 0){
                            self.chartView.models = self.createModels() // order is important - models have to be set at the end
                        }
                    }
                    
                    
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Message", message: "No Records Found"), animated: true, completion: nil)
                }
                
            }
            
        }else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        
    }
    
    fileprivate func createModels() -> [PieSliceModel] {
        var returnArray = [PieSliceModel]()
        if let array = self.blackPointsArray {
            if(array.count > 0) {
                if let bPoints = array[0].BLACK_POINTS, let mPoints = array[0].MAX_BLACK_POINTS {
                    
                    let rPoints = mPoints - bPoints
                    if(bPoints > mPoints){
                        returnArray.removeAll()
                        returnArray.append(PieSliceModel(value: 5, exactVal: Double(bPoints), color: UIColor.black))
                        
                        exceedingBlackPoint.text = "\(bPoints)"
                        exceedingBlackPoint.textColor = UIColor.white
                        exceedingBlackPoint.font = UIFont(name: "Avenir Next", size: 20)
                        self.chartView.strokeWidth = 0
                    }
                    else{
                        returnArray.removeAll()
                        self.chartView.strokeWidth = 6
                        let bValue = (Double(bPoints) * 5)/Double(mPoints)
                        let rValue = (Double(rPoints) * 5)/Double(mPoints)
                        returnArray.append(PieSliceModel(value: bValue, exactVal: Double(bPoints), color: UIColor.black))
                        returnArray.append(PieSliceModel(value: rValue, exactVal: Double(rPoints), color: UIColor.rgb(red: 27, green: 184, blue: 43)))
                    }
                    
                    
                }
                
            }
        }
        return returnArray
    }
    
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 135
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        
        //viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 118
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.init(name: "Avenir Next", size: 20)!
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        
        textLayerSettings.label.textGenerator = {slice in
            return "\(Int(slice.data.model.exactValue) )"
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
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
    
    
    

    
 
    
    func setUpBlackPoints(){
        
        
        if let array =  self.blackPointsArray {
           if (array.count > 0){
            if let max = array[0].MAX_BLACK_POINTS, let points = array[0].BLACK_POINTS {
                if(UserProfileDefaults.isEnglish){
                    if(points > max){
                        self.totalPointsTextLAbel.text = "Total Maximum Points = \(points)"
                    }else{
                   self.totalPointsTextLAbel.text = "Total Maximum Points = \(max)"
                    }
                   self.blackPointsTextLabel.text = "Black Points"
                   self.remainingPointsTextLabel.text = "Remaining Points "
                    self.blackPointsLabel.text = String(points)
                    self.remainigPoints.text = String(max - points)
                }else{
                    if(points > max){
                        let mpoints = NSLocalizedString("Total Maximum Points" , comment: "")
                        self.totalPointsTextLAbel.text = "\(mpoints) = \(points)"
                    }else{
                    let mpoints = NSLocalizedString("Total Maximum Points" , comment: "")
                    self.totalPointsTextLAbel.text = "\(mpoints) = \(max)"
                    }
                     self.blackPointsTextLabel.text = NSLocalizedString("Black points" , comment: "")
                    self.remainingPointsTextLabel.text = NSLocalizedString("Remaining Points", comment: "")
                    self.blackPointsLabel.text = String(points)
                    self.remainigPoints.text = String(max - points)
                   
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
