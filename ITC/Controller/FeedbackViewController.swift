//
//  FeedbackViewController.swift
//  ITC
//
//  Created by Harsha M G on 12/02/18.
//  Copyright © 2018 infinitesol. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var scrollVw: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let feedBackView = UINib(nibName: "FeedbackQuestionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FeedbackQuestionView
        
        self.scrollVw.contentSize = CGSize.init(width: self.scrollVw.frame.width, height: feedBackView.frame.height)
        self.scrollVw.addSubview(feedBackView)
        feedBackView.frame = CGRect.init(x: 0, y: 0, width: scrollVw.frame.width, height: feedBackView.frame.height)
//        self.scrollVw.addConstraints(with: "H:|[v0]|", views: feedBackView)
        
        
        
        
        
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
