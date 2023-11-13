//
//  ContactsTableViewManager.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/9.
//

import Foundation
import UIKit
import FirebaseFirestore

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewContactsID, for: indexPath) as! ContactsTableViewCell
        let participants = chatsList[indexPath.row].participants
        
        // TODO: implement group chat
        
        var friendEmail = ""
        
        for email in participants {
            if email == currentUser?.email {
                continue
            }
            friendEmail = email
        }
        
        db.collection("users").document(friendEmail).getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                let friendName = document["name"] as? String ?? "Unknown"
                cell.labelName.text = friendName
            } else {
                print("Document does not exist")
            }
        }

        // cell.labelName.text = chatsList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open the chatView Screen
        let chatViewController = ChatViewController()
        chatViewController.messagesList = chatsList[indexPath.row].messages
        
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
