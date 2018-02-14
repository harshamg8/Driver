//
//  DefaultTextField.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DefaultLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        
        font = masterLabelFont
        textColor = .black
    }
}

@IBDesignable
class DefaultTextField: FloatingTextField {
    
    let paddingSize = CGFloat(5.0)
    var isShowPasswordRequired: Bool = false {
        didSet {
            if isShowPasswordRequired {
                
                setupShowPassword()
            }
        }
    }
    
    var showPasswordButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        lineHeight = 0
        selectedLineHeight = 0
        
        selectedTitleColor = .black
        titleColor = .black
    }
    
    func setupShowPassword() {
            
            isSecureTextEntry = true
            
            showPasswordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            showPasswordButton?.addTarget(self, action: #selector(DefaultTextField.showPassword), for: .touchUpInside)
            showPasswordButton?.setImage(#imageLiteral(resourceName: "show").withRenderingMode(.alwaysTemplate), for: .normal)
            showPasswordButton?.imageView?.tintColor = masterTextColor
            
            rightViewMode = .always
            rightView = showPasswordButton
    }
    
    @objc func showPassword() {
        
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            showPasswordButton?.setImage(#imageLiteral(resourceName: "show").withRenderingMode(.alwaysTemplate), for: .normal)
        }
        else {
            showPasswordButton?.setImage(#imageLiteral(resourceName: "hide").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingSize, y: bounds.origin.y, width: bounds.size.width - paddingSize, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingSize, y: bounds.origin.y, width: bounds.size.width - paddingSize, height: bounds.size.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingSize, y: bounds.origin.y, width: bounds.size.width - paddingSize, height: bounds.size.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 10
        return rect
    }
}
