//
//  PermitCardCell.swift
//  ITC
//
//  Created by Harsha M G on 13/01/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class PermitCardCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var permitCardCollectionView: UICollectionView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        permitCardCollectionView.delegate = self
        permitCardCollectionView.dataSource = self
        
        if let flowLayout = permitCardCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        
        let permitCardFrontSide = UINib(nibName: "PermitCardFrontSideCell", bundle: nil)
        permitCardCollectionView.register(permitCardFrontSide, forCellWithReuseIdentifier: "frontSideCell")
        
        let permitCardBackSide = UINib(nibName: "PermitCardBackSideCell", bundle: nil)
        permitCardCollectionView.register(permitCardBackSide, forCellWithReuseIdentifier: "backSideCell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "frontSideCell", for: indexPath) as! PermitCardFrontSideCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "backSideCell", for: indexPath) as! PermitCardBackSideCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.permitCardCollectionView.frame.width, height: self.permitCardCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}


 class CardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //loadNib()
    }
    
    
    override func awakeFromNib() {
        APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
            if(isCompleted){
                let card = driverArray[0][1]
                self.loadNib(card: card)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //loadNib()
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadNib(card: String) {
        
        if(card.lowercased() == "airport taxi"){
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "AirportTaxiCardViewFront", bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.frame = bounds
            
            self.addSubview(view)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // view.frame = CGRect.init(x: 8, y:8, width:self.frame.width - 16, height: self.frame.height)
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            
        }
        
        else if(card.lowercased() == "silver taxi"){
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "SilverTaxiCardViewFront", bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.frame = bounds
            
            self.addSubview(view)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // view.frame = CGRect.init(x: 8, y:8, width:self.frame.width - 16, height: self.frame.height)
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
        }
        
        else{
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "PStatusView", bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.frame = bounds
            
            self.addSubview(view)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // view.frame = CGRect.init(x: 8, y:8, width:self.frame.width - 16, height: self.frame.height)
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
        
        }
        
        
        
       
    }
    
}


class BackCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //loadNib()
    }
    
    
    override func awakeFromNib() {
        APIService.sharedInstance.fetchDriverDetails { (driverArray, isCompleted) in
            if(isCompleted){
                let card = driverArray[0][1]
                self.loadNib(card: card)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //loadNib()
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadNib(card: String) {
        
        if(card.lowercased() == "airport taxi" || card.lowercased() == "silver taxi" ){
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "AirportTaxiAndSilverTaxiCardBack", bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.frame = bounds
            
            self.addSubview(view)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // view.frame = CGRect.init(x: 8, y:8, width:self.frame.width - 16, height: self.frame.height)
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            
        }
            
       
            
        else{
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "LimousineCardBack", bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.frame = bounds
            
            self.addSubview(view)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // view.frame = CGRect.init(x: 8, y:8, width:self.frame.width - 16, height: self.frame.height)
            view.layer.cornerRadius = 10
            view.layer.masksToBounds = true
            
        }
        
        
        
        
    }
    
    
}













