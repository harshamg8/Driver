//
//  SubmitGrievanceController.swift
//  ITC
//
//  Created by Harsha M G on 15/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit
import Photos

class SubmitGrievanceController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var vw = UIView()
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var violationIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var remarksTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var violationIdTextLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var selectTypeTextLabel: UILabel!
    @IBOutlet weak var remarksTextLabel: UILabel!
    @IBOutlet weak var doc1TextLabel: UILabel!
    @IBOutlet weak var remark1TextLabel: UILabel!
    @IBOutlet weak var doc2TextLabel: UILabel!
    @IBOutlet weak var remark2TextLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var doc1Imageview: UIImageView!
    
    @IBOutlet weak var doc2ImgeView: UIImageView!
    @IBOutlet weak var attach1buton: UIButton!
    @IBOutlet weak var attach2Button: UIButton!
    
    @IBOutlet weak var remarks1TextField: UITextField!
    
    @IBOutlet weak var remarks2TextField: UITextField!
   
    let grievancePickerView: UIPickerView = UIPickerView()
    var articleName: String?
    var violationId: Int?
    var locationName: String?
    var status: String?
    var serviceType = ""
    var remarks = ""
    var fineNumber: String?
    
    var grievanceArray: [GrievanceLookUp]?
    var imageData1: [UInt8]?
    var imageData2: [UInt8]?
    var extension1 =  ""
    var extension2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageData1 = [UInt8]()
        imageData2 = [UInt8]()
        addButton.isHidden = false
        hideUiElements(value: true)
        
        let titleView = UINib(nibName: "TitleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleView
        
        titleView.permitNumberLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        if(UserProfileDefaults.isEnglish){
            titleView.PageTitleLabel.text = "Grievance"
        }else{
            titleView.PageTitleLabel.text = NSLocalizedString("Grievance", comment: "")
        }
        
        titleView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView
        
        attach1buton.tag = 0
        attach2Button.tag = 0
        
        if let article = articleName {
            articleLabel.text = article
        }else{
            articleLabel.text = ""
        }
        if let fineNumberFromFine = self.fineNumber {
            violationIdLabel.text = fineNumberFromFine
        }else{
            violationIdLabel.text = ""
        }
        
        if let statusString = status {
            statusLabel.text = statusString
        }else{
            statusLabel.text = ""
        }
        
        if(UserProfileDefaults.isEnglish){
            
            violationIdTextLabel.text = "Fine Number"
            statusTextLabel.text = "Status"
            remarksTextLabel.text = "Remarks"
            submitButton.setTitle("SUBMIT", for: .normal)
        }else{
            
            
            violationIdTextLabel.text = NSLocalizedString("Fine Number", comment: "")
            
            statusTextLabel.text = NSLocalizedString("Status", comment: "")
            remarksTextLabel.text = NSLocalizedString("Remarks", comment: "")
            submitButton.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
        }
        
        if(Reachability.isConnectedToNetwork()){
            setupActivityIndicator()
            APIService.sharedInstance.grievanceLookup { (grievanceArray, isCompleted) in
                if(isCompleted){
                    self.grievanceArray = grievanceArray
                    self.removeActivityIndicatorView()
                }else{
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Sorry", message: "You can't submit Grievance as Grievance Type is not available"), animated: true, completion: nil)
                }
            }
        }else{
             self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
        }
        
        
        
        

        
        setUpPickerViews()
        setUpToolBar()
  }
   
    
    func setUpPickerViews() {
        grievancePickerView.delegate = self
        grievancePickerView.dataSource = self
        typeTextField.inputView = grievancePickerView
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        typeTextField.resignFirstResponder()
    }
    
    func setUpToolBar(){
        let toolBar = UIToolbar(frame: CGRect.init(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.rgb(red: 184, green: 41, blue: 37)
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(donePressed))
        toolBar.setItems([okBarBtn], animated: true)
        typeTextField.inputAccessoryView = toolBar
        
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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let array = grievanceArray{
            return array.count
        }else{
        return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let array = grievanceArray{
            if(UserProfileDefaults.isEnglish){
                return array[row].NAME_EN
            }else{
                return array[row].NAME_AR
            }
            
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let array = grievanceArray{
            if(UserProfileDefaults.isEnglish){
                typeTextField.text = array[row].NAME_EN
            }else{
                typeTextField.text = array[row].NAME_AR
            }
            
            if let value = array[row].ID {
                print(String(value))
                serviceType = String(value)
            }
        }else{
            typeTextField.text = ""
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == typeTextField){
            if(typeTextField.text == ""){
                if (grievanceArray != nil) {
                    self.grievancePickerView.selectRow(0, inComponent: 0, animated: true)
                    self.pickerView(grievancePickerView.self, didSelectRow: 0, inComponent: 0)
                }
                
            }
        }
    }
    
    
    func hideUiElements(value: Bool){
        doc2ImgeView.isHidden = value
        doc2TextLabel.isHidden = value
        remark2TextLabel.isHidden = value
        attach2Button.isHidden = value
        remarks2TextField.isHidden = value
        
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {

        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        }, completion: nil)
        addButton.isHidden = true
        hideUiElements(value: false)
        
    }
    
    
    

    @IBAction func attacheButtonTapped(_ sender: UIButton) {
       // guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        DispatchQueue.main.async {
            self.typeTextField.resignFirstResponder()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus)in
                    switch status{
                    case .denied:
                        self.present(Alert.createErrorAlert(title: "This App doesn't have access to your Photos", message: "You can enable access in Settings."), animated: true, completion: nil)
                        break
                    case .authorized:
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.delegate = self
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.allowsEditing = false
                        self.present(imagePickerController, animated: true, completion: nil)
                        break
                        
                        
                    default:
                        self.present(Alert.createErrorAlert(title: "This App doesn't have access to your Photos", message: "You can enable access in Settings."), animated: true, completion: nil)
                        break
                    }
                })
                
                if(sender == self.attach1buton){
                    self.attach1buton.tag = 1
                    self.attach2Button.tag = 0
                }
                else{
                    self.attach2Button.tag = 1
                    self.attach1buton.tag = 0
                    
                }
                
            }
            
        }
       
        
    }
    
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
           // submit(image: image)
            
            if(attach1buton.tag == 1){
                doc1Imageview.image = image
                let imagepath = info[UIImagePickerControllerReferenceURL] as? URL
                if let iPath = imagepath {
                    let fName =  iPath.pathExtension
                    if let imageData = UIImageJPEGRepresentation(image,0.3){
                        imageData1 = returnByteArray(imageData: imageData)
                        extension1 = fName
                    }
                
                    
                    
                }
                
            }
            else{
                doc2ImgeView.image = image
                let imagepath = info[UIImagePickerControllerReferenceURL] as? URL
                if let iPath = imagepath {
                    let fName =  iPath.pathExtension
                    if let imageData = UIImageJPEGRepresentation(image, 0.3) {
                        imageData2 = returnByteArray(imageData: imageData)
                        extension2 = fName
                    }
                    
                }
            }
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
           // submit(image: image)
            if(attach1buton.tag == 1){
                doc1Imageview.image = image
                let imagepath = info[UIImagePickerControllerReferenceURL] as? URL
                if let iPath = imagepath {
                    let fName =  iPath.pathExtension
                    if let imageData = UIImageJPEGRepresentation(image, 0.3) {
                        imageData1 = returnByteArray(imageData: imageData)
                        extension1 = fName
                    }
                    
                }
            }
            else{
                doc2ImgeView.image = image
                let imagepath = info[UIImagePickerControllerReferenceURL] as? URL
                if let iPath = imagepath {
                    let fName =  iPath.pathExtension
                    if let imageData = UIImageJPEGRepresentation(image, 0.3){
                        imageData2 = returnByteArray(imageData: imageData)
                        extension2 = fName
                    }
                    
                }
            }
        }
        
        picker.dismiss(animated: true)
        
    }
 

    func returnByteArray(imageData: Data) -> [UInt8] {
        
        let count = imageData.count / MemoryLayout<UInt8>.size
        var array1 = [UInt8](repeating: 0, count: count)
        imageData.copyBytes(to: &array1, count: count * MemoryLayout<UInt8>.size)
        var byteArray:[UInt8] = [UInt8]()
        
        for i in 0..<count {
            //byteArray.append(UInt8(value: array1[i]))
            byteArray.append(UInt8(array1[i]))
        }
        
        return byteArray
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitGrievanceButtonTapped(_ sender: UIButton) {
        
        if(Reachability.isConnectedToNetwork()){
            
            if let rmrks = remarksTextField.text {
                remarks = rmrks
            }else{
                remarks = ""
            }
            if let violId = violationId{
                if(serviceType != ""){
                    if(remarksTextField.text != ""){
                        setupActivityIndicator()
                        
                        GrievanceAPI.sharedInstance.submitGrievance(type: serviceType, remarks: remarks, violationId: String(violId),image1Data: imageData1, image2data: imageData2, extension1: extension1, extension2: extension2, remarks1: remarks1TextField.text!, remaks2: remarks2TextField.text!, completion: { (isCompleted,message ) in
                            
                            if(isCompleted){
                                self.removeActivityIndicatorView()
                                let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    self.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                                // self.present(Alert.createErrorAlert(title: "Message", message: message), animated: true, completion: nil)
                            }else{
                                self.removeActivityIndicatorView()
                                let alert = UIAlertController(title: "Sorry", message: "Unable to Submit", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    self.navigationController?.popViewController(animated: true)
                                })
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                                //self.present(Alert.createErrorAlert(title: "Sorry", message: "Unable to Submit"), animated: true, completion: nil)
                            }
                        })
                    }else{
                        self.removeActivityIndicatorView()
                        self.present(Alert.createErrorAlert(title: "Error", message: "Remarks should not be empty"), animated: true, completion: nil)
                    }
                    
                }
                else {
                    self.removeActivityIndicatorView()
                    self.present(Alert.createErrorAlert(title: "Error", message: "Type should not be empty"), animated: true, completion: nil)
                }
            }
            else {
                self.removeActivityIndicatorView()
                self.present(Alert.createErrorAlert(title: "Error", message: "Violation Id is misssing"), animated: true, completion: nil)
            }
            
        }else{
            self.present(Alert.createErrorAlert(title: "No Internet", message: "Please check your internet connectivity"), animated: true, completion: nil)
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
