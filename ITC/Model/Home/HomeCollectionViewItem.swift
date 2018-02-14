//
//  HomeCollectionViewItem.swift
//  ITC
//
//  Created by Harsha M G on 14/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class HomeCollectionViewItem: NSObject {

    var nameEn : HomeCollectionViewItemsEnum
    var nameAr : HomeCollectionViewItemsArabicEnum
    let imageName: String
    
    init(nameEn: HomeCollectionViewItemsEnum,imageName: String, nameAr: HomeCollectionViewItemsArabicEnum) {
        self.nameEn = nameEn
        self.imageName = imageName
        self.nameAr = nameAr
    }
    
}
