//
//  ChatViewController.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    var messagesList: [Message] = []
    var chatView = ChatView()
    var currentUser:FirebaseAuth.User?
    
    var participants = [String]()
    
    var friendEmail = ""
    var friendName = ""
    
    let db = Firestore.firestore()
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPreviousChat()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatView.tableViewMessages.register(MyMessageChatTableViewCell.self, forCellReuseIdentifier: "myMessage")
        chatView.tableViewMessages.register(FriendMessageChatTableViewCell.self, forCellReuseIdentifier: "friendMessage")
        chatView.tableViewMessages.delegate = self
        chatView.tableViewMessages.dataSource = self
        chatView.tableViewMessages.separatorStyle = .none
        
//        messagesList = [
//            Message(sender: "livia2@test.com", receiever: "livia1@test.com", text: "Hello!", time: Date()),
//            Message(sender: "livia1@test.com", receiever: "livia2@test.com",text: "Hi there!", time: Date())
//        ]
        
        showPreviousChat()
        

        chatView.buttonAdd.addTarget(self, action: #selector(onButtonAddTapped), for: .touchUpInside)
    }
    
    @objc func onButtonAddTapped() {
        guard let currentUserEmail = currentUser?.email else {
            print(currentUser)
            print("Can't find current user")
            return
        }
        guard let text = chatView.textViewMessage.text else {
            // show alert text can not be empty
            return
            
        }
        let newMessage = Message(
                            sender: currentUserEmail,
                            receiever: friendEmail,
                            text: text,
                            time: Date())
        var key = ""
        if friendEmail < currentUserEmail {
            key = friendEmail + currentUserEmail
        } else {
            key = currentUserEmail + friendEmail
        }
        messagesList.append(newMessage)
        
        
        let updatedChat = Chat(participants: participants, messages: messagesList)
        
        updateMessageToFirebase(updatedChat: updatedChat, key: key) { result in
            switch result {
            case .success:
                print("Message updated successfully")
                self.clearTextField()
                self.showPreviousChat()
            case .failure(let error):
                print("Error updating message: \(error.localizedDescription)")
            }
        }
    }
    
    func updateMessageToFirebase(updatedChat: Chat, key: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("chats").document(key).setData(from: updatedChat) { error in
                if let error = error {
                    print("Error updating chat object: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Chat updated in Firebase")
                    completion(.success(()))
                }
            }
        } catch {
            print("Error setting data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    
    func clearTextField() {
        chatView.textViewMessage.text = ""
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
        print("scrollToLastMessage triggered")
    }
    
    func formatDate(_ timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
    

}
