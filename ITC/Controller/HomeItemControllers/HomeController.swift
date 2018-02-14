//
//  HomeController.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class HomeController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SegmentedControlClicked {
    
    @IBOutlet weak var idsView: UIView!
    @IBOutlet weak var permitNumberTextLabel: UILabel!
    
    var homeEn = "Home"
    var homeAr = "الصفحة الرئيسية"
    var vw = UIView()
    
    @IBOutlet weak var menubutton: UIBarButtonItem!
    let cellId = "cellID"
    var home: HomeCollectionViewItem?
    var isEnglish: Bool = true
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
        
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.permitNumberTextLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
    }
    
    let homeCollectionViewItems: [HomeCollectionViewItem] = {
        return [HomeCollectionViewItem(nameEn: .Fine, imageName: "fine", nameAr: .Fine),HomeCollectionViewItem(nameEn: .Points, imageName: "points", nameAr: .Points),HomeCollectionViewItem(nameEn: .Exam, imageName: "exam", nameAr: .Exam),HomeCollectionViewItem(nameEn: .Permits, imageName: "permits", nameAr:.Permits),HomeCollectionViewItem(nameEn: .Complaints, imageName: "complaints", nameAr: .Complaints),HomeCollectionViewItem(nameEn: .CarProfile, imageName: "car_profile", nameAr: .CarProfile),HomeCollectionViewItem(nameEn: .Inspection, imageName: "inspection", nameAr: .Inspection),HomeCollectionViewItem(nameEn: .Training, imageName: "training", nameAr: .Training),HomeCollectionViewItem(nameEn: .Investigation, imageName: "investigation", nameAr: .Investigation),HomeCollectionViewItem(nameEn: .Grievance, imageName: "grievance", nameAr: .Grievance)]
        
    }()
    
    func didSegmetedControlTapped(isEnglishSelected: Bool, object: SwitchView) {
        self.permitNumberTextLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        self.isEnglish = isEnglishSelected
        self.collectionView.reloadData()
        if(isEnglishSelected){
            self.tabBarController?.tabBarItem.title = homeEn
            self.navigationItem.title = "Home"
            self.permitNumberTextLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        }else{
            self.tabBarController?.tabBarItem.title = homeAr
            self.navigationItem.title = NSLocalizedString("Home", comment: "")
           
            if let number = UserProfileDefaults.permitNumber{
                self.permitNumberTextLabel.text = "\(NSLocalizedString("Permit number", comment: "")): \(number)"
            }
            
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.permitNumberTextLabel.text = Helper.getPermitNumberBasedOnTheLanguage()
        
        let switchView = UINib(nibName: "SwitchView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SwitchView
        switchView.delegate = self
        let barButton = UIBarButtonItem(customView: switchView)
        self.navigationItem.rightBarButtonItem = barButton
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = (self.view.frame.width * (3/4))
            menubutton.target = self.revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        setupCollectionView()
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        
        APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
            if(isCompleted){
                self.removeActivityIndicatorView()
            }
            else{
                self.removeActivityIndicatorView()
                
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
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
 
    
    func setupCollectionView(){
        view.addSubview(bottomView)
        bottomView.addSubview(collectionView)
        
        view.addConstraints(with: "H:|-2-[v0]-2-|", views: bottomView)
        view.addConstraints(with: "V:|-32-[v0]-53-|", views: bottomView)
        
//        view.addConstraints(with: "H:|-8-[v0]-8-|", views: collectionView)
//        view.addConstraints(with: "V:|[v0]-49-|", views: collectionView)
        view.addConstraints(with: "H:|-4-[v0]-4-|", views: collectionView)
        view.addConstraints(with: "V:|-4-[v0]-4-|", views: collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 25, left: 2, bottom: 10, right: 2)
        collectionView.layer.cornerRadius = 15
        collectionView.layer.masksToBounds = true

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCollectionViewItems.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCollectionViewCell
        if(self.isEnglish){
            cell.menuLabel.text = homeCollectionViewItems[indexPath.item].nameEn.rawValue
        }else{
            cell.menuLabel.text = homeCollectionViewItems[indexPath.item].nameAr.rawValue
        }
        
        cell.menuImageView.image = UIImage(named: homeCollectionViewItems[indexPath.item].imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        home = homeCollectionViewItems[indexPath.row]
        if(self.isEnglish){
            switch home?.nameEn {
            case .Fine?:
                self.performSegue(withIdentifier: "toFine", sender: self)
                break
                
            case .Permits? :
                self.performSegue(withIdentifier: "toPermit", sender: self)
                break
                
            case .Exam? :
                self.performSegue(withIdentifier: "toExam", sender: self)
                break
                
            case .Points? :
                self.performSegue(withIdentifier: "toPoints", sender: self)
                break
                
            case .CarProfile? :
                self.performSegue(withIdentifier: "toCarProfile", sender: self)
                break
                
            case .Complaints? :
                self.performSegue(withIdentifier: "toComplaint", sender: self)
                break
                
          
                
            case .Inspection? :
                self.performSegue(withIdentifier: "toInspection", sender: self)
                break
                
            case .Investigation? :
                self.performSegue(withIdentifier: "toInvestigation", sender: self)
                break
                
            case .Training? :
                self.performSegue(withIdentifier: "toTraining", sender: self)
                break
                
            case .Grievance? :
                self.performSegue(withIdentifier: "toGrievance", sender: self)
                break
                
            default:
                break
            }
        
        }else{
            
            switch home?.nameAr {
            case .Fine?:
                self.performSegue(withIdentifier: "toFine", sender: self)
                break
                
            case .Permits? :
                self.performSegue(withIdentifier: "toPermit", sender: self)
                break
                
            case .Exam? :
                self.performSegue(withIdentifier: "toExam", sender: self)
                break
                
            case .Points? :
                self.performSegue(withIdentifier: "toPoints", sender: self)
                break
                
            case .CarProfile? :
                self.performSegue(withIdentifier: "toCarProfile", sender: self)
                break
                
            case .Complaints? :
                self.performSegue(withIdentifier: "toComplaint", sender: self)
                break
          
                
            case .Inspection? :
                self.performSegue(withIdentifier: "toInspection", sender: self)
                break
                
            case .Investigation? :
                self.performSegue(withIdentifier: "toInvestigation", sender: self)
                break
                
            case .Training? :
                self.performSegue(withIdentifier: "toTraining", sender: self)
                break
                
            case .Grievance? :
                self.performSegue(withIdentifier: "toGrievance", sender: self)
                break

                
                
            default:
                break
            }
            
        }
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 6) / 3
        return CGSize.init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch home?.name {
//        case .Fine? :
//            let vc = segue.destination as! DriverFine
//            performSegue(withIdentifier: "toFine", sender: self)
//            break
//
//        default:
//            print("")
//        }
//
//        }
    }




