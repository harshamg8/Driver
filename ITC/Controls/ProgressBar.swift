//
//  ProgressBar.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//
import Foundation
import UIKit

extension UIViewController {
    func showProgress() {
        
        let progress = ProgressBar(frame: view.frame)
        view.addSubview(progress)
        progress.show()
    }
    
    func showProgress(with message: String) {
        
        let progress = ProgressBar.init(frame: view.frame, with: message)
        view.addSubview(progress)
        progress.show()
    }
}

class ProgressBar: UIView {
    
    let shapeLayer = CAShapeLayer()
    
    var message: String?
    
    let lblMessage: UILabel = {
        
        let label = UILabel()
        return label
    }()
    
    init(frame: CGRect, with message: String) {
        super.init(frame: frame)
        self.message = message
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        
        backgroundColor = .gray
        lblMessage.adjustsFontSizeToFitWidth = true
        lblMessage.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
        lblMessage.center = center
        lblMessage.text = message
        shapeLayer.addSublayer(lblMessage.layer)
        
    }
    
    func show() {
        
        perform(#selector(addAnimation), with: self, afterDelay: 1.0)
    }
    
    @objc func addAnimation() {
        
        // your dot diameter.
        let dotDiameter: CGFloat = 5.0;
        
        // your 'expected' dot spacing. we'll try to get as closer value to this as possible.
        let expDotSpacing: CGFloat = 10.0;
        
        // the size of your view
        let s = frame.size
        
        // the radius of your circle, half the width or height (whichever is smaller) with the dot radius subtracted to account for stroking
        let radius = (s.width < s.height) ? s.width*0.5-dotDiameter*0.5 : s.height*0.5-dotDiameter*0.5
        
        // the circumference of your circle
        let circum = CGFloat.pi * radius * 2.0
        
        // the number of dots to draw as given by the circumference divided by the diameter of the dot plus the expected dot spacing.
        let numberOfDots = CGFloat(4) //round(circum/(dotDiameter+expDotSpacing))
        
        // the calculated dot spacing, as given by the circumference divided by the number of dots, minus the dot diameter.
        let dotSpacing: CGFloat = (circum/numberOfDots) - dotDiameter;
        
        let path = UIBezierPath(arcCenter: (superview?.center)!, radius: 40, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true).cgPath
        
        shapeLayer.frame = CGRect(x: 0, y: 0, width: s.width, height: s.height)
        shapeLayer.path = path
        shapeLayer.lineWidth = dotDiameter
        shapeLayer.strokeColor = masterColor.cgColor
        shapeLayer.lineCap = kCALineCapRound
        
        let so = Int(dotSpacing + dotDiameter)
        shapeLayer.lineDashPattern = [0, NSNumber(value: so)]
        //        shapeLayer.lineDashPattern = [10, 5, 5, 5]
        
        shapeLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.toValue = 0.5
        animation.duration = 5
        animation.repeatCount = Float(Int.max)
        animation.isRemovedOnCompletion = true
        
        shapeLayer.add(animation, forKey: "")
    }
    
}

