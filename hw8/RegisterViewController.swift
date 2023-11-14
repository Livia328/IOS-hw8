//
//  RegisterViewController.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/9.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    let childProgressView = ProgressSpinnerViewController()
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
    }
    
    @objc func onRegisterTapped(){
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let passwordText = registerView.textFieldPassword.text,
           let repeatPasswordText = registerView.textFieldRepeatPassword.text{
            if !name.isEmpty && !email.isEmpty && !passwordText.isEmpty && !repeatPasswordText.isEmpty {
                if emailIsValid(email) {
                    if passwordText == repeatPasswordText {
                        //MARK: creating a new user on Firebase...
                        registerNewAccount(email: email, name: name, password: passwordText)
                        self.notificationCenter.post(name: .userRegistered, object: nil)
                    } else {
                        showAlert(text: "Password is not macth.")
                    }
                } else {
                    showAlert(text: "Invalid Email")
                }
            } else {
                showAlert(text: "Empty Values.")
            }
        } else{
            showAlert(text: "Empty Values.")
        }
    }

    
    func showAlert(text:String){
        let alert = UIAlertController(
            title: "Error",
            message: "\(text)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func emailIsValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

