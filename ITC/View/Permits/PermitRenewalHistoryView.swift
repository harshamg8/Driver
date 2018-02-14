//
//  PermitRenewalHistoryView.swift
//  ITC
//
//  Created by Harsha M G on 29/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class PermitRenewalHistoryView: UICollectionViewCell {

    @IBOutlet weak var renewalHistoryTableView: UITableView!
    var renewhistoryArray: [PermitRenewalHistory]?
    @IBOutlet weak var noRecordsFoundLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        renewalHistoryTableView.delegate = self
        renewalHistoryTableView.dataSource = self
        
        let tableCell = UINib(nibName: "RenewalHistoryCell", bundle: nil)
        renewalHistoryTableView.register(tableCell, forCellReuseIdentifier: "cellId")
        
        if(Reachability.isConnectedToNetwork()){
            if (renewhistoryArray != nil){
            noRecordsFoundLabel.isHidden = true
                noRecordsFoundLabel.text = ""
                renewalHistoryTableView.reloadData()

        }else{
            noRecordsFoundLabel.isHidden = false
            noRecordsFoundLabel.text = "No Records found"
        }
    }else{
        noRecordsFoundLabel.text = "No Internet"
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

extension PermitRenewalHistoryView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.renewhistoryArray {
            return array.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! RenewalHistoryCell
        if let array = self.renewhistoryArray{
            noRecordsFoundLabel.isHidden = true
            cell.history = array[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
}
