//
//  ChatViewController.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/12.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController {
    
    var messagesList: [Message] = []
    var chatView = ChatView()
    var currentUser:FirebaseAuth.User?
    
    override func loadView() {
        view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
