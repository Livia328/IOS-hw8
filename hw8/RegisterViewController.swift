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
        //MARK: creating a new user on Firebase...
        registerNewAccount()
        // notice the mainscreen that user registered
        self.notificationCenter.post(name: .userRegistered, object: nil)
    }
}

