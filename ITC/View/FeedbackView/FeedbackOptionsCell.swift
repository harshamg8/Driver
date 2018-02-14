//
//  FeedbackOptionsCell.swift
//  ITC
//
//  Created by Harsha M G on 12/02/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

protocol OptionDelegate {
    func didClickOption(option:FeedbackOptions)
}

class FeedbackOptionsCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    var delegate: OptionDelegate?
    
    var option: FeedbackOptions?{
        didSet{
            if let obj = option?.OptionText{
                optionLabel.text = obj
            }
            
            optionButton.addTarget(self, action: #selector(optionButtonPressed), for: .touchUpInside)
        }
    }
    
    func initCellForrdioButton(){
        let deselectedImage = UIImage(named: "circle_empty")?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: "circle_filled")?.withRenderingMode(.alwaysOriginal)
        optionButton.setImage(deselectedImage, for: .normal)
        optionButton.setImage(selectedImage, for: .selected)
        
    }
    
    @objc func optionButtonPressed() {
       // optionButton.setImage(UIImage.init(named: "circle_filled"), for: .normal)
        let isSelected = !self.optionButton.isSelected
        self.optionButton.isSelected = isSelected
        if isSelected {
            deselectOtherButton()
        }
        
    }
    func deselectAll(){
        if(optionButton.isSelected){
            optionButton.isSelected = false
        }
    }
    
    
    func deselectOtherButton() {
        let tableView = self.contentView.superview?.superview as! UITableView
        let tappedCellIndexPath = tableView.indexPath(for: self)!
        let section = tappedCellIndexPath.section
        let rowCounts = tableView.numberOfRows(inSection: section)
        
        for row in 0..<rowCounts {
            if row != tappedCellIndexPath.row {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! FeedbackOptionsCell
                cell.optionButton.isSelected = false
            }else{
                if let del = delegate{
                    if let obj = option{
                        del.didClickOption(option: obj)
                        }
                    }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
