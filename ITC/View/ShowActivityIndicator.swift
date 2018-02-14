//
//  ShowActivityIndicator.swift
//  ITC
//
//  Created by Harsha M G on 16/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class ShowAndRemoveActivityIndicator: UIView {

    static func setupActivityIndicator() -> UIView {
        let vw = UIView()
        vw.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        myActivityIndicator.hidesWhenStopped = false
        vw.addSubview(myActivityIndicator)
        myActivityIndicator.center = vw.center
        myActivityIndicator.startAnimating()
        return vw
    }

}
