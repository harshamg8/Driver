//
//  FeedbackQuestion1OptionsCell.swift
//  ITC
//
//  Created by Harsha M G on 12/02/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit
protocol FromQuestionTableviewDelegate {
    func didRecieveOptionsAndQuestions(option: FeedbackOptions)
}
class FeedbackQuestion1OptionsCell: UITableViewCell,OptionDelegate {
    func didClickOption(option: FeedbackOptions) {
        if let del = delegate{
            del.didRecieveOptionsAndQuestions(option: option)
        }
    }
    

    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var feedbackOptionsArray: [FeedbackOptions]?
    var feedbackQuestionsArray: [FeedbackQuestion]?
   
    var multipleChoiceArray: [FeedbackQuestion]?
    var freeTextArray: [FeedbackQuestion]?
    
    var tableSourceOptionsArray: [FeedbackOptions]?
    var delegate: FromQuestionTableviewDelegate?
    
    var isSubmitted: Bool = false
    
    var question: FeedbackQuestion?{
        didSet{
            
            if let obj = question?.Question{
                self.questionLabel.text = obj
            }
            tableSourceOptionsArray?.removeAll()
            if let qId = question?.QuestionID{
                if let oArray = feedbackOptionsArray{
                for option in oArray{
                    if let oQID = option.QuestionID{
                        if(qId == oQID){
                            tableSourceOptionsArray?.append(option)
                        }
                    }
                }
                    
                    optionsTableView.reloadData()
                }
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        tableSourceOptionsArray = [FeedbackOptions]()
        feedbackOptionsArray = [FeedbackOptions]()
        isSubmitted = false
        
        let tableCell = UINib(nibName: "FeedbackOptionsCell", bundle: nil)
        optionsTableView.register(tableCell, forCellReuseIdentifier: "cell3")
        
    }
    
    func eraseSelection(){
        isSubmitted = true
        optionsTableView.reloadData()
        //isSubmitted = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FeedbackQuestion1OptionsCell: UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let oArray = tableSourceOptionsArray {
            return oArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! FeedbackOptionsCell
        cell.delegate = self
        if let array = tableSourceOptionsArray{
            cell.initCellForrdioButton()
            cell.option = array[indexPath.row]
        }
        if(isSubmitted){
            cell.deselectAll()
        }
        return cell
        
    }
   
    
    
}
