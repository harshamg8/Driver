//
//  RegisterView.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

protocol RegisterViewDelegate {
    
    func registerButtonTapped()
    func cancelButtonTapped()
}

@IBDesignable
class RegisterView: UIView {
    
    @IBInspectable dynamic open var textFieldHeight: CGFloat = 40.0 {
        didSet {
            clearConstraints()
            removeSubViews()
            setupViews()
        }
    }
    
    @IBInspectable dynamic open var leadingTrailingSpacing: CGFloat = 10.0 {
        didSet {
            clearConstraints()
            removeSubViews()
            setupViews()
        }
    }
    
    //Setting of logo image and logo visibility
    @IBInspectable var logoImage: UIImage? {
        
        didSet {
            logoImageView.image = logoImage
        }
    }
    
    @IBInspectable var hideLogo: Bool = false {
        
        didSet {
            if hideLogo {
                logoImageHeightConstraint?.constant = 0
            }
            else {
                logoImageHeightConstraint?.constant = 72
            }
        }
    }
    
    fileprivate var logoImageHeightConstraint: NSLayoutConstraint?
    fileprivate var logoImageWidthConstraint: NSLayoutConstraint?
    
    open var isShowPasswordRequired: Bool = false {
        didSet {
            txtPassword.isShowPasswordRequired = isShowPasswordRequired
            txtConfirmPassword.isShowPasswordRequired = isShowPasswordRequired
        }
    }
    
    //UIElements for display
    
    var logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let lblHeader: DefaultLabel = {
        let label = DefaultLabel()
        label.font = masterLabelFont.withSize(20.0)
        label.text = "Register"
        label.textColor = masterTextColor
        label.sizeToFit()
        return label
    }()
    
    var txtFirstName: DefaultTextField = {
        let textField = DefaultTextField()
        textField.placeholder = "First Name"
        textField.titleColor = masterTextColor
        textField.selectedTitleColor = textField.titleColor
        return textField
    }()
    
    var txtLastName: DefaultTextField = {
        let textField = DefaultTextField()
        textField.placeholder = "Last Name"
        textField.titleColor = masterTextColor
        textField.selectedTitleColor = textField.titleColor
        return textField
    }()
    
    var txtEmail: DefaultTextField = {
        let textField = DefaultTextField()
        textField.placeholder = "Email"
        textField.isEmailType = true
        textField.titleColor = masterTextColor
        textField.selectedTitleColor = textField.titleColor
        return textField
    }()
    
    var txtPassword: DefaultTextField = {
        let textField = DefaultTextField()
        textField.placeholder = "Password"
        textField.titleColor = masterTextColor
        textField.selectedTitleColor = textField.titleColor
        return textField
    }()
    
    var txtConfirmPassword: DefaultTextField = {
        let textField = DefaultTextField()
        textField.placeholder = "Password"
        textField.titleColor = masterTextColor
        textField.selectedTitleColor = textField.titleColor
        return textField
    }()
    
    var btnCancel: ReversedDefaultButton = {
        
        let button = ReversedDefaultButton()
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(RegisterView.btnCancel_Tapped), for: .touchUpInside)
        return button
    }()
    
    var btnRegister: DefaultButton = {
        
        let button = DefaultButton()
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(RegisterView.btnRegister_Tapped), for: .touchUpInside)
        return button
    }()
    
    lazy var parentViewController: UIViewController? = {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }()
    
    var delegate: RegisterViewDelegate?
    
    fileprivate var scrollView: UIScrollView?
    fileprivate var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        
        scrollView = UIScrollView()
        contentView = UIView()
        
        addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        contentView!.addSubview(logoImageView)
        contentView!.addSubview(lblHeader)
        contentView!.addSubview(txtFirstName)
        contentView!.addSubview(txtLastName)
        contentView!.addSubview(txtEmail)
        contentView!.addSubview(txtPassword)
        contentView!.addSubview(txtConfirmPassword)
        contentView!.addSubview(btnCancel)
        contentView!.addSubview(btnRegister)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        addConstraints(with: "H:|[v0]|", views: scrollView!)
        addConstraints(with: "V:|[v0]|", views: scrollView!)
        
        scrollView?.addConstraints(with: "H:|[v0]|", views: contentView!)
        scrollView?.addConstraints(with: "V:|[v0]|", views: contentView!)
        
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 153)
        logoImageWidthConstraint?.isActive = true
        
        logoImageHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 72)
        logoImageHeightConstraint?.isActive = true
        
        contentView?.addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]", views: lblHeader)
        contentView?.addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: txtFirstName)
        contentView?.addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: txtLastName)
        contentView?.addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: txtEmail)
        contentView?.addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: txtPassword)
        contentView?.addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: txtConfirmPassword)
        contentView?.addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-[v1]-\(leadingTrailingSpacing)-|", views: btnCancel, btnRegister)
        
        contentView?.addConstraints(with: "V:|-50-[v0]", views: logoImageView)
        contentView?.addConstraints(with: "V:[v0]-50-[v1]", views: logoImageView, lblHeader)
        contentView?.addConstraints(with: "V:[v0]-20-[v1]-30-[v2]-30-[v3]-30-[v4]-30-[v5]", views: lblHeader, txtFirstName, txtLastName, txtEmail, txtPassword, txtConfirmPassword)
        contentView?.addConstraints(with: "V:[v0]-30-[v1]", views: txtConfirmPassword, btnCancel)
        
        let verticalSpacing: CGFloat = 705.0 //Adding the space between the ui elements and their height + 20
        
        contentView?.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        contentView?.heightAnchor.constraint(equalToConstant: verticalSpacing).isActive = true
        
        scrollView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: verticalSpacing).isActive = true
        
        btnCancel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnRegister.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        txtFirstName.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        txtLastName.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        txtEmail.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        txtPassword.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        btnRegister.widthAnchor.constraint(equalTo: btnCancel.widthAnchor, multiplier: 1.0).isActive = true
        btnRegister.centerYAnchor.constraint(equalTo: btnCancel.centerYAnchor).isActive = true
        
        lblHeader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    //MARK: - Button Actions
    
    @objc fileprivate func btnRegister_Tapped() {
        
        for view in subviews {
            
            if view is UITextField, ((view as! UITextField).text?.trimmedLength)! < 1 {
                
                let alertView = Alert.createErrorAlert(title: "Mandatory", message: ErrorMessage.fieldsMandatory.rawValue)
                parentViewController?.present(alertView, animated: true, completion: nil)
                return
            }
        }
        
        if txtPassword.text != txtConfirmPassword.text {
            
            let alertView = Alert.createErrorAlert(title: "Password not matching", message: ErrorMessage.passwordNotMatching.rawValue)
            
            txtPassword.text = ""
            txtConfirmPassword.text = ""
            
            parentViewController?.present(alertView, animated: true, completion: nil)
            return
        }
        
        delegate?.registerButtonTapped()
    }
    
    @objc fileprivate func btnCancel_Tapped() {
        
        delegate?.cancelButtonTapped()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    
    
    
    
    
    
    
    
    
    
    
    
}
