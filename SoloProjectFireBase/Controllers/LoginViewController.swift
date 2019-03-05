//
//  LoginViewController.swift
//  SoloProjectFireBase
//
//  Created by Olimpia on 2/24/19.
//  Copyright © 2019 Olimpia. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginView: LoginView!
    private var usersession: UserSession!
    private var accountLoginState = AccountLoginState.newAccount
    override func viewDidLoad() {
        super.viewDidLoad()
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession.userSessionCreateAccountDelegate = self
        usersession.userSessionCreateAccountDelegate = self
        usersession.usersessionSignInDelegate = self
        loginView.delegate = self
        loginView.EmailTextField.delegate = self
        loginView.PasswordTextField.delegate = self
    }
    
}

extension LoginViewController: LoginViewDelegate {
    func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState) {
        guard let email = loginView.EmailTextField.text,
            let password = loginView.PasswordTextField.text ,
            !email.isEmpty,
            !password.isEmpty else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required", actionTitle: "Try Again")
                return
        }
        switch accountLoginState {
        case .newAccount:
            usersession.createNewAccount(email: email, password: password)
        case .existingAccount:
            usersession.signInExistingUser(email: email, password: password)
        }
    }
}

extension LoginViewController: UserSessionAccountCreationDelegate {
    func didCreateAccount(_ userSession: UserSession, user: User) {
       
        
        showAlert(title: "Account Created", message: "Account created using \(user.email ?? "no email entered") ", style: .alert) { (alert) in
             self.existingUser()
        }
    }
    
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        showAlert(title: "error", message: "you error is \(error.localizedDescription)", actionTitle: "whatver")
    }
    
    
}

extension LoginViewController: UserSessionSignInDelegate {
    func didRecieveSignInError(_ usersession: UserSession, error: Error) {
         showAlert(title: "Sign In Error", message: error.localizedDescription, actionTitle: "Try Again")
    }
    
    func didSignInExistingUser(_ usersession: UserSession, user: User) {
        self.existingUser()
    }
    
    private func existingUser() {
        let storyboard = UIStoryboard(name: "TaskStoryBoard", bundle: nil)
       let homeVC = storyboard.instantiateViewController(withIdentifier: "TasksTabBarController") as! TasksTabBarController
       homeVC.modalTransitionStyle = .crossDissolve
        homeVC.modalPresentationStyle = .overFullScreen
        self.present(homeVC, animated: true)

    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let email = loginView.EmailTextField.text,
            let password = loginView.PasswordTextField.text ,
            !email.isEmpty,
            !password.isEmpty else {
                return false
        }
        switch accountLoginState {
        case .newAccount:
            usersession.createNewAccount(email: email, password: password)
        case .existingAccount:
            usersession.signInExistingUser(email: email, password: password)
        }
        
        return true
        
    }
}



    




