//
//  FilterController.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

class FilterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
    }

    override func viewDidAppear(_ animated: Bool) {
        if(UserProfileDefaults.isEnglish){
            self.tabBarItem.title = "Filter"
            self.navigationItem.title = "Filter"
        }else{
            self.tabBarItem.title = NSLocalizedString("Filter", comment: "")
            self.navigationItem.title = NSLocalizedString("Filter", comment: "")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
