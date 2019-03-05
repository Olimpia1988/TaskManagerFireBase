//
//  LoginView.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/24/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit

// states of login
enum AccountLoginState {
    case newAccount
    case existingAccount
}

// delegate for the LoginView
protocol LoginViewDelegate: AnyObject {
    func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState)
}


class LoginView: UIView {
    
    public weak var delegate: LoginViewDelegate?
    
    @IBOutlet var LonginView: UIView!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
 
    private var tapGesture: UITapGestureRecognizer!
    private var accountLoginState = AccountLoginState.newAccount
    
    // coming from programmatic ui code
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    // coming from storyboard or nib/.xib file
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // bridging helper methods
    private func commonInit() {
        // load the nib/.xib file
        Bundle.main.loadNibNamed("loginView", owner: self, options: nil)
        addSubview(LonginView)
        // content view takes size of self.bounds
        LonginView.frame = bounds
        LonginView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // setup button action
        createButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        // setup message label actions
        // setup tap gesture recognizer
        
        // UILabel and UIImageView by default isUserInteractionEnabled is false, thus not allowing for gesture recognition by the user
        createLabel.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        createLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func loginButtonPressed() {
        
        
        
    delegate?.didSelectLoginButton(self, accountLoginState: accountLoginState)


    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        accountLoginState = accountLoginState == .newAccount ? .existingAccount : .newAccount
        switch accountLoginState {
        case .newAccount:
            createButton.setAttributedTitle(NSAttributedString(string: "Create"), for: .normal)
            createLabel.text = "New User? Create an account"

        case .existingAccount:
            createLabel.text = "Login into your account"
            createButton.setAttributedTitle(NSAttributedString(string: "Login"), for: .normal)
        }
    }

        
}
