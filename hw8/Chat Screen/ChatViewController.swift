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
        
        chatView.tableViewMessages.register(MyMessageChatTableViewCell.self, forCellReuseIdentifier: "myMessage")
        chatView.tableViewMessages.register(FriendMessageChatTableViewCell.self, forCellReuseIdentifier: "friendMessage")
        chatView.tableViewMessages.delegate = self
        chatView.tableViewMessages.dataSource = self
        chatView.tableViewMessages.separatorStyle = .none
        
        messagesList = [
            Message(sender: "livia2@test.com", receiever: "livia1@test.com", text: "Hello!", time: Date()),
            Message(sender: "livia1@test.com", receiever: "livia2@test.com",text: "Hi there!", time: Date())
        ]
        
        showPreviousChat()
        

        chatView.buttonAdd.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
    }
    
    @objc func onButtonAddTapped() {
        
    }
    
    func showPreviousChat() {
        chatView.tableViewMessages.reloadData()
        scrollToLastMessage(animated: false)
    }
    
    func scrollToLastMessage(animated: Bool) {
        if messagesList.isEmpty{
            return
        }
        let lastIndexPath = IndexPath(row: messagesList.count - 1, section: 0)
        chatView.tableViewMessages.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
    }
    
    func formatDate(_ timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
    

}
