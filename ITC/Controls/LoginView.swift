//
//  LoginView.swift
//  ITC
//
//  Created by Harsha M G on 13/12/17.
//  Copyright © 2017 infinitesol. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraints(with format: String, views: UIView...) {
        
        var dictViews = [String:UIView]()
        
        for (index, view) in views.enumerated() {
            
            dictViews["v\(index)"] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: dictViews))
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        removeConstraints(constraints)
    }
    
    func removeSubViews() {
        
        subviews.map({ $0.removeFromSuperview() })
    }
}

protocol LoginViewDelegate {
    
    func loginButtonTapped()
    func cancelButtonTapped()
}


@IBDesignable
open class LoginView: UIView {
    
    @objc enum LoginTheme: Int {
        case Default
        case Center
    }
    
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
    
    var loginRequest: URLRequest?
    var gradientLayer: CAGradientLayer?
    
    var delegate: LoginViewDelegate?
    
    var password = ""
    
    //Theme for login screen
    var theme: LoginTheme = .Default {
        
        didSet {
            clearConstraints()
            removeSubViews()
            setupViews()
        }
    }
    
    @IBInspectable var themeIndex: Int {
        get {
            return theme.rawValue
        }
        set (themeIndex) {
            theme = LoginTheme(rawValue: themeIndex) ?? .Default
        }
    }
    
    @IBInspectable dynamic open var textFieldHeight: CGFloat = 40.0 {
        didSet {
            clearConstraints()
            removeSubViews()
            setupViews()
        }
    }
    
    @IBInspectable dynamic open var buttonHeight: CGFloat = 40.0 {
        didSet {
            clearConstraints()
            removeSubViews()
            setupViews()
        }
    }
    
    //Gradient color
    @IBInspectable var gradientStartColor: UIColor = .clear {
        
        didSet {
            gradientLayer?.removeFromSuperlayer()
            createGradientLayer()
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor = .clear {
        
        didSet {
            gradientLayer?.removeFromSuperlayer()
            createGradientLayer()
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
                logoImageHeightConstraint?.constant = 100
            }
        }
    }
    
    @IBInspectable dynamic open var leadingTrailingSpacing: CGFloat = 20.0 {
        didSet {
            clearConstraints()
            removeSubViews()
            setupViews()
        }
    }
    
    //Dynamic Size for Button and Image
    @IBInspectable open var loginImageSize: CGSize = CGSize.zero {
        
        didSet {
            logoImageView.removeConstraints([loginButtonWidthConstraint!, loginButtonHeightConstraint!])
            
            logoImageWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: loginImageSize.width)
            logoImageWidthConstraint?.isActive = true
            
            logoImageHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: (loginImageSize.height))
            logoImageHeightConstraint?.isActive = true
        }
    }
    
    @IBInspectable var loginButtonSize: CGSize = CGSize.zero {
        
        didSet {
            btnLogin.removeConstraints([loginButtonWidthConstraint!, loginButtonHeightConstraint!])
            
            loginButtonWidthConstraint = btnLogin.widthAnchor.constraint(equalToConstant: loginButtonSize.width)
            loginButtonWidthConstraint?.isActive = true
            
            loginButtonHeightConstraint = btnLogin.heightAnchor.constraint(equalToConstant: loginButtonSize.height)
            loginButtonHeightConstraint?.isActive = true
        }
    }
    
    //Constriants for height and width of UIElements
    fileprivate var logoImageHeightConstraint: NSLayoutConstraint?
    fileprivate var logoImageWidthConstraint: NSLayoutConstraint?
    fileprivate var logoImageCenterYConstraint: NSLayoutConstraint?
    fileprivate var loginButtonHeightConstraint: NSLayoutConstraint?
    fileprivate var loginButtonWidthConstraint: NSLayoutConstraint?
    fileprivate var txtUserNameWidthConstraint: NSLayoutConstraint?
    fileprivate var txtPasswordWidthConstraint: NSLayoutConstraint?
    
    
    //UIElements initialization
    var txtUsername: DefaultTextField = {
        
        let textField = DefaultTextField()
        textField.placeholder = "Username"
        return textField
    }()
    
    var txtPassword: DefaultTextField = {
        
        let textField = DefaultTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var btnLogin: DefaultButton = {
        
        let button = DefaultButton()
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(LoginView.btnLogin_Tapped), for: .touchUpInside)
        return button
    }()
    
    var btnCancel: ReversedDefaultButton = {
        
        let button = ReversedDefaultButton()
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(LoginView.btnCancel_Tapped), for: .touchUpInside)
        return button
    }()
    
    var logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //MARK: - UIViewController LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    //MARK: - Custom Functions - Setting up View and Constraints
    
    fileprivate func setupViews() {
        
        addSubview(logoImageView)
        addSubview(txtUsername)
        addSubview(txtPassword)
        addSubview(btnLogin)
        addSubview(btnCancel)
        
        //        addSubview(btnFacebookLogin)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        logoImageWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 100)
        logoImageWidthConstraint?.isActive = true
        
        loginButtonHeightConstraint = btnLogin.heightAnchor.constraint(equalToConstant: buttonHeight)
        loginButtonHeightConstraint?.isActive = true
        
        txtUsername.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        txtPassword.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        logoImageHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 100)
        logoImageHeightConstraint?.isActive = true
        
        btnLogin.widthAnchor.constraint(equalTo: btnCancel.widthAnchor).isActive = true
        btnCancel.centerYAnchor.constraint(equalTo: btnLogin.centerYAnchor).isActive = true
        btnCancel.heightAnchor.constraint(equalTo: btnLogin.heightAnchor).isActive = true
        
        switch theme {
        case .Default:
            constraintForDefault()
            break
            
        case .Center:
            constraintForCenter()
            break
            
        }
        
    }
    
    fileprivate func constraintForDefault() {
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageCenterYConstraint = logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        logoImageCenterYConstraint?.isActive = true
        
        addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: txtUsername)
        addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: txtPassword)
        addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-10-[v1]-\(leadingTrailingSpacing)-|", views: btnCancel, btnLogin)
        
        addConstraints(with: "V:[v0]-20-[v1]", views: txtUsername, txtPassword)
        addConstraints(with: "V:[v0]-20-[v1]-30-|", views: txtPassword, btnLogin)
    }
    
    fileprivate func constraintForCenter() {
        
        logoImageView.contentMode = .scaleAspectFit
        
        //Stackview to hold Username and Password fields
        let stackView = UIStackView(arrangedSubviews: [txtUsername, txtPassword])
        stackView.axis = .vertical
        stackView.alignment = .fill
        addSubview(stackView)
        
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        //Stacckview to hold Login and Register Button
        let buttonStackView = UIStackView(arrangedSubviews: [btnCancel, btnLogin])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        addSubview(buttonStackView)
        
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //Adding constraints with visual formats in Horizontal and Vertical
        addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: stackView)
        addConstraints(with: "H:|-\(leadingTrailingSpacing)-[v0]-\(leadingTrailingSpacing)-|", views: buttonStackView)
        
        addConstraints(with: "V:[v0]-\(leadingTrailingSpacing)-[v1]", views: stackView, buttonStackView)
        addConstraints(with: "V:[v0]-\(leadingTrailingSpacing)-[v1]", views: logoImageView, stackView)
    }
    
    fileprivate func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.frame = bounds
        gradientLayer?.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    //MARK: - Button Actions
    
    @objc fileprivate func btnLogin_Tapped() {
        
        if (txtUsername.text?.trimmedLength)! < 1 || (txtPassword.text?.trimmedLength)! < 1 {
            
            let alertView = Alert.createErrorAlert(title: "Mandatory", message: "Username and Password is mandatory")
            parentViewController?.present(alertView, animated: true, completion: nil)
            return
        }
        
        delegate?.loginButtonTapped()
    }
    
    @objc fileprivate func btnCancel_Tapped() {
        
        delegate?.cancelButtonTapped()
    }
    
    //MARK: - Orientation Management
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if theme == .Default {
            
            removeConstraint(logoImageCenterYConstraint!)
            
            if UIDevice.current.orientation.isLandscape  {
                logoImageCenterYConstraint = logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
            }
            else {
                logoImageCenterYConstraint = logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
            }
            logoImageCenterYConstraint?.isActive = true
            
        }
        
    }
    
}


