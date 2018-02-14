//
//  FeedbackQuestionView.swift
//  ITC
//
//  Created by Harsha M G on 12/02/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit
protocol FromFeedbackquestionViewDelegate {
    func didFetchQuestionsAndOptions(didfetch: Bool)
    func didtapOnSubmit(feedbackArray: [[String:Any]], isDone: Bool)
}
class FeedbackQuestionView: UIView,FromQuestionTableviewDelegate,FromSuggestionDelegate {
    
    
    var delegate: FromFeedbackquestionViewDelegate?
    
    func didRecieveOptionsAndQuestions(option: FeedbackOptions) {
        self.option = option
        var myDict = [String:Any]()
        
        if let array = finalArray {
            if(array.count > 0){
                for i in 0..<array.count{
                    if let qId = option.QuestionID{
                        
                            let obj = array[i]
                            if(obj["QuestionID"] as? Int == qId){
                                finalArray?.remove(at: i)
                            }
                        }
                    }
                }
            }
            if let qId = option.QuestionID{
                if let oId = option.OptionID{
                    myDict = ["QuestionID":qId, "OptionID":oId,"Remarks":""]
                    finalArray?.append(myDict)
                }
            }
        
    }
    
    func didFinishtypingSuggestion(text: String, freeTextQuestion: FeedbackQuestion) {
        suggestion = text
        sugeestionDict = [String:Any]()
        if let qId = freeTextQuestion.QuestionID{
           sugeestionDict = ["QuestionID":qId,"OptionID":0,"Remarks":text]
        }
        
    }
    
    

    @IBOutlet weak var feedbackQuestionTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var questionArray: [FeedbackQuestion]?
    var questionOptionsArray: [FeedbackOptions]?
    var multipleQuestionsArray: [FeedbackQuestion]?
    var freeTextQuestionArray: [FeedbackQuestion]?
    var mCount = 0
    var fCount = 0
    var option: FeedbackOptions?
    var suggestion = ""
    var finalArray: [[String:Any]]?
    var sugeestionDict: [String:Any]?
    
    override func awakeFromNib() {
        feedbackQuestionTableView.delegate = self
        feedbackQuestionTableView.dataSource = self
        
        if(UserProfileDefaults.isEnglish){
            submitButton.setTitle("SUBMIT", for: .normal)
        }else{
            submitButton.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
        }
        
        multipleQuestionsArray = [FeedbackQuestion]()
        freeTextQuestionArray = [FeedbackQuestion]()
        finalArray = [[String:Any]]()
        submitButton.layer.cornerRadius = 5
        submitButton.layer.masksToBounds = true
        
        let tableCell1 = UINib(nibName: "FeedbackQuestion1OptionsCell", bundle: nil)
        feedbackQuestionTableView.register(tableCell1, forCellReuseIdentifier: "cell1")
        
        let tableCell2 = UINib(nibName: "FeedbackQuestion2OptionsCell", bundle: nil)
        feedbackQuestionTableView.register(tableCell2, forCellReuseIdentifier: "cell2")
        
        APIService.sharedInstance.fetchFeedbackQuestions { (feedbackQuestionsArray, isCompleted) in
            if(isCompleted){
                if(feedbackQuestionsArray.count > 0){
                    self.questionArray = feedbackQuestionsArray
                    APIService.sharedInstance.fetchFeedbackOptions(completion: { (feedbackoptionsArray, isCompleted) in
                        if(isCompleted){
                            self.questionOptionsArray = feedbackoptionsArray
                            self.configureTableView()
                            if let del = self.delegate{
                                del.didFetchQuestionsAndOptions(didfetch: true)
                            }
                        }else{
                            if let del = self.delegate{
                             del.didFetchQuestionsAndOptions(didfetch: false)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func configureTableView(){
        
        if let array = self.questionArray{
            if(array.count > 0){
                
                for obj in array {
                    if(obj.QuestionType == "MULTIPLECHOICE"){
                        multipleQuestionsArray?.append(obj)
                    }else if(obj.QuestionType == "FREETEXT"){
                        freeTextQuestionArray?.append(obj)
                    }
                }

                DispatchQueue.main.async {
                    self.feedbackQuestionTableView.reloadData()
                }
                
            }
        }

        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let dummyArray = [[String:Any]]()
        
        if let sugDict = sugeestionDict{
            if(sugDict.count > 0){
                finalArray?.append(sugDict)
            }
            
        }
                if let array = finalArray{
                    if(array.count > 0){
                        for dict in array{
                            if(dict.count > 0){
                                delegate?.didtapOnSubmit(feedbackArray: array, isDone: true)
                                
                                break
                            }else{
                                delegate?.didtapOnSubmit(feedbackArray: dummyArray, isDone: false)
                            }
                        }
                    }else{
                        
                        delegate?.didtapOnSubmit(feedbackArray: dummyArray, isDone: false)
                    }
                    
                }else{
                    delegate?.didtapOnSubmit(feedbackArray: dummyArray, isDone: false)
                }
                
           
        finalArray?.removeAll()
        sugeestionDict = nil
        feedbackQuestionTableView.reloadData()
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension FeedbackQuestionView: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if(section == 0) {
            if let array = self.multipleQuestionsArray
            {
                if(array.count > 0){
                    count = array.count
                }
            }

        }else{
            count = 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        if(indexPath.section == 1){
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! FeedbackQuestion2OptionsCell
            cell.delegate = self
            if let array = freeTextQuestionArray {
                if(array.count > 0){
                    cell.freeText = array[indexPath.row]
                }
               
            }
            if let array = finalArray{
                if(array.count > 0){
                    
                }
                else{
                    cell.eraseSugeestions()
                }
            }else{
                cell.eraseSugeestions()
            }
            return cell
        }else{
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! FeedbackQuestion1OptionsCell
            cell.delegate = self
            if let array = multipleQuestionsArray{
                if(array.count > 0){
                    
                    if let oArray = questionOptionsArray{
                        if(oArray.count > 0){
                            cell.feedbackOptionsArray = oArray
                        }
                    cell.multipleChoiceArray = array
                    cell.question = array[indexPath.row]
                }
                
            }
            
            }
            
            if let array = finalArray{
                if(array.count > 0){
                    
                }else{
                    cell.eraseSelection()
                }
            }else{
                cell.eraseSelection()
            }

            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 190
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

















