//
//  PermitSuspensionHistoryView.swift
//  ITC
//
//  Created by Harsha M G on 29/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class PermitSuspensionHistoryView: UICollectionViewCell {

    @IBOutlet weak var suspensionHistoryTableView: UITableView!
    @IBOutlet weak var noRecordFoundLabel: UILabel!
    
    var suspensionHistoryArray: [PermitSuspensionHistory]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        suspensionHistoryTableView.delegate = self
        suspensionHistoryTableView.dataSource = self
        let tableCell = UINib(nibName: "SuspensionHistoryCell", bundle: nil)
        suspensionHistoryTableView.register(tableCell, forCellReuseIdentifier: "cellId")
        if(Reachability.isConnectedToNetwork()){
            if (suspensionHistoryArray != nil) {
             noRecordFoundLabel.isHidden = true
                noRecordFoundLabel.text = ""
            suspensionHistoryTableView.reloadData()
        }else{
                noRecordFoundLabel.isHidden = false
                noRecordFoundLabel.text = "No Records found"
        }
        } else{
            noRecordFoundLabel.text = "No Internet"
        }
        
    }
 
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension PermitSuspensionHistoryView: UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.suspensionHistoryArray{
            return array.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SuspensionHistoryCell
        if let array = self.suspensionHistoryArray{
            noRecordFoundLabel.isHidden = true
            cell.suspension = array[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
