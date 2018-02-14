//
//  ProfileController.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ProfileController: UIViewController,UITableViewDataSource,UITableViewDelegate, SegmentedControlClicked,MobileNumberCellDelegate {
    
    

    @IBOutlet weak var profileTableView: UITableView!
    
    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    
    var driverArray: [[String]]?
    let sectionNamesEn = ["Profile Image","Franchise Details","Permit Details","Driver Details","Mobile Number"]
    
    let sectionNamesAr = ["Profile Image",NSLocalizedString("Franchise Details", comment: ""),NSLocalizedString("Permit Details", comment: ""),NSLocalizedString("Driver Details", comment: ""),"Mobile Number"]
    
    let categoryArrayEn = [["Franchise Name","Franchise Type"], ["Pemit Number","Permit Issue Date","Permit Renew date","Permit Expiry Date","Permit Status"], ["Name","License Number","License Source Id","License Expiry Date","Profile Status","Driver Status","Date Of Birth"]]
    
    let categoryArrayAr = [[NSLocalizedString("Franchise Name", comment: ""),NSLocalizedString("Franchise Type", comment: "")], [NSLocalizedString("Permit number", comment: ""),NSLocalizedString("Permit Issue Date", comment: ""),NSLocalizedString("Permit Renew Date", comment: ""),NSLocalizedString("Permit Expiry Date", comment: ""),NSLocalizedString("Permit Status", comment: "")], [NSLocalizedString("Name", comment: ""),NSLocalizedString("License Number", comment: ""),NSLocalizedString("License Source Id", comment: ""),NSLocalizedString("License Expiry Date", comment: ""),NSLocalizedString("Profile status", comment: ""),NSLocalizedString("Driver status", comment: ""),NSLocalizedString("Date of birth", comment: "")]]
    
    
    var vw = UIView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let switchView = UINib(nibName: "SwitchView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SwitchView
        switchView.delegate = self
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
       
        if(UserProfileDefaults.isEnglish){
            self.navigationItem.title = "Profile"
        }else{
           
            self.navigationItem.title = NSLocalizedString("Profile", comment: "")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.profileTableView.reloadData()
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
                if(isCompleted){
                    self.driverArray = driverArray
                    
                    self.profileTableView.reloadData()
                    self.removeActivityIndicatorView()
                }
                else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Message", message: "No Records Found"), animated: true, completion: nil)
                }
                
            }
        }
        else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        if(UserProfileDefaults.isEnglish){
            self.navigationItem.title = "Profile"
            
        }else{
            self.navigationItem.title = NSLocalizedString("Profile", comment: "")
            
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.driverArray != nil){
            return sectionNamesEn.count

        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        if(section == 0){
           return 1
        }
        
        else if section == 1 {
            if let array = driverArray{
                rows = array[0].count
            }
            
        }
        else if section == 2{
            if let array = driverArray{
                rows = array[1].count
            }
        }
        else if(section == 4){
            return 1
        }
        else if(section == 3) {
            if let array = driverArray{
                rows = array[2].count
            }
        }else{
            rows = 1
        }
        
        return rows
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let tableCell = UITableViewCell()
        
        
        
        
        if(UserProfileDefaults.isEnglish){
            if let array = driverArray {
                if(indexPath.section == 0){
                    let profileImageCell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! ProfileImageCell
                    
                    if let photoString = UserProfileDefaults.driverPhoto{
                        if let decodedData = Data(base64Encoded: photoString, options: .ignoreUnknownCharacters){
                            profileImageCell.profileImageView.image = UIImage(data: decodedData)
                        }
                        
                    }else{
                        
                    }
                    return profileImageCell
                }
                
                else if(indexPath.section == 4){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId3", for: indexPath) as! MobileNumberCell
                    cell.mobileNumberTextField.text = UserProfileDefaults.mobileNumber
                    cell.mobileNumberLabel.text = "Mobile Number"
                    cell.delegate = self
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! ProfileCell
                    if(indexPath.section == 1){
                        
                        cell.categoryLabel.text = categoryArrayEn[0][indexPath.row]
                        cell.descriptionLabel.text = array[0][indexPath.row]
                    }else if(indexPath.section == 2){
                        cell.categoryLabel.text = categoryArrayEn[1][indexPath.row]
                        cell.descriptionLabel.text = array[1][indexPath.row]
                    }
                    else {
                        cell.categoryLabel.text = categoryArrayEn[2][indexPath.row]
                        cell.descriptionLabel.text = array[2][indexPath.row]
                    }
                    return cell
                }
               
            }
            
        }else{
            if let array = DriverDetailsUserDefault.driverDetails {
                if(indexPath.section == 0){
                    let profileImageCell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! ProfileImageCell
                    
                    if let photoString = UserProfileDefaults.driverPhoto{
                        if let decodedData = Data(base64Encoded: photoString, options: .ignoreUnknownCharacters){
                            profileImageCell.profileImageView.image = UIImage(data: decodedData)
                        }
                        
                    }else{
                        
                    }
                    return profileImageCell
                }
                else if(indexPath.section == 4){
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId3", for: indexPath) as! MobileNumberCell
                    cell.mobileNumberTextField.text = UserProfileDefaults.mobileNumber
                    cell.mobileNumberLabel.text = NSLocalizedString("Mobile Number", comment: "")
                    cell.delegate = self
                    return cell
                    
                }else{
                   
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! ProfileCell
                    if(indexPath.section == 1){
                        
                        cell.categoryLabel.text = categoryArrayAr[0][indexPath.row]
                        cell.descriptionLabel.text = array[0][indexPath.row]
                    }else if(indexPath.section == 2){
                        cell.categoryLabel.text = categoryArrayAr[1][indexPath.row]
                        cell.descriptionLabel.text = array[1][indexPath.row]
                    }
                    else {
                        cell.categoryLabel.text = categoryArrayAr[2][indexPath.row]
                        cell.descriptionLabel.text = array[2][indexPath.row]
                    }
                    return cell
                    
                }
                
                

                

            }
        }

       return tableCell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UINib(nibName: "ProfileTableSectionHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileSectionHeaderView
        
            if(UserProfileDefaults.isEnglish){
                sectionView.sectionNameLabel.text = sectionNamesEn[section]
            }else{
                sectionView.sectionNameLabel.text = sectionNamesAr[section]
            }
        
        
        return sectionView

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0 || section == 4){
            return 0
        }else{
            return 60

        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 329
        }else if(indexPath.section == 4){
            return 130
        }
        
        else{
            return 80
        }
        
        
    }
    
   /*
    @IBAction func editBarButtonTapped(_ sender: UIBarButtonItem) {
       
        let mobileNumberEn = "Mobile Number"
        let mobileNumberAr = "رقم الهاتف المتحرك"
        var mobileNumberTextField: UITextField?
        
        // 2.
        var alertController = UIAlertController()
        if(UserProfileDefaults.isEnglish){
            alertController = UIAlertController(
                
                title: mobileNumberEn,
                message: mobileNumberEn,
                preferredStyle: UIAlertControllerStyle.alert)
            
        }else{
            alertController = UIAlertController(
                
                title: mobileNumberAr,
                message: mobileNumberAr,
                preferredStyle: UIAlertControllerStyle.alert)
            
        }
        
        // 3.
        let updateAction = UIAlertAction(
        title: "Update", style: UIAlertActionStyle.default) {
            (action) -> Void in
            self.setupActivityIndicator()
            if let mobileNumber = mobileNumberTextField?.text {
                APIService.sharedInstance.changeMobileNumber(mobileNumber: mobileNumber, completion: { (isCompleted, message) in
                    if(isCompleted){
                        self.removeActivityIndicatorView()
                        self.present(Alert.createErrorAlert(title: "Success", message: message), animated: true, completion: nil)

                    }else{
                        self.removeActivityIndicatorView()
                        self.present(Alert.createErrorAlert(title: "Another request exists which is not yest processed", message: message), animated: true, completion: nil)
                    }
                })
            
            }
        }
        // 4.
        if(UserProfileDefaults.isEnglish){
            alertController.addTextField {
                (txtUsername) -> Void in
                mobileNumberTextField = txtUsername
                mobileNumberTextField!.placeholder = mobileNumberEn
                mobileNumberTextField?.keyboardType = UIKeyboardType.phonePad
            }
        }else{
            alertController.addTextField {
                (txtUsername) -> Void in
                mobileNumberTextField = txtUsername
                mobileNumberTextField!.placeholder = mobileNumberAr
                mobileNumberTextField?.keyboardType = UIKeyboardType.phonePad
            }
        }
        
        
        // 5.
        alertController.addAction(updateAction)
        self.present(alertController, animated: true, completion: nil)
   }
    */
    
    func didSegmetedControlTapped(isEnglishSelected: Bool, object: SwitchView) {
        self.profileTableView.reloadData()
        if(isEnglishSelected){
            self.navigationItem.title = "Profile"
            self.tabBarItem.title = "Profile"
        }else{
            self.navigationItem.title = NSLocalizedString("Profile", comment: "")
            self.tabBarItem.title = NSLocalizedString("Profile", comment: "")
        }
    }
    
    func didClickEditButton(mobilenumberCell: MobileNumberCell, mobileNumber: String) {
        APIService.sharedInstance.changeMobileNumber(mobileNumber: mobileNumber, completion: { (isCompleted, message) in
            if(isCompleted){
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "Success", message: message), animated: true, completion: nil)
                self.profileTableView.reloadData()
                
                
            }else{
                self.removeActivityIndicatorView()
                self.profileTableView.reloadData()
                self.present(Alert.createErrorAlert(title: "Sorry", message: message), animated: true, completion: nil)
            }
        })

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
