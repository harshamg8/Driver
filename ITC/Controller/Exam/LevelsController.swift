//
//  LevelsController.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class LevelsController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var levelTableView: UITableView!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    
    @IBOutlet weak var profileIdLabel: UILabel!
    @IBOutlet weak var permitNumberLabel: UILabel!
    
    
    var levelArray: [Level]?
    var serviceType: String?
    var examCenterArray = [ExamCenterLookUp]()
    var questionairId: Int?
    var vw = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileIdLabel.text = Helper.getProfileIdBasedOnTheLanguage()
        permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        levelTableView.delegate = self
        levelTableView.dataSource = self
        setupActivityIndicator()
        APIService.sharedInstance.fetchExamCenterLookup { (examCenterArray,isCompleted ) in
            if(isCompleted){
                self.examCenterArray = examCenterArray
                self.removeActivityIndicatorView()
                self.noRecordFoundLabel.text = ""
            }else{
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "Sorry", message: "No Records Found"), animated: true, completion: nil)
                self.noRecordFoundLabel.text = "No Records Found"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = levelArray {
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! LevelCell
        if let array = levelArray {
            if(UserProfileDefaults.isEnglish){
                cell.levelLabel.text = array[indexPath.row].LEVEL_DESCRION_EN
            }else{
                cell.levelLabel.text = array[indexPath.row].LEVEL_DESCRION_AR
            }
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let array = levelArray {
            questionairId = array[indexPath.row].QUESTIONAIRE_ID
            self.performSegue(withIdentifier: "toBookExam", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let vc = segue.destination as! BookExamController
        vc.examCenterArray = self.examCenterArray
        if let type = serviceType {
            vc.serviceType = type
        }
        if let questionId = questionairId{
            vc.questionairId = questionId
        }
    }
    

}
