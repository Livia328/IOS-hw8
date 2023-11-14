//
//  ChatTableViewManager.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/12.
//

import Foundation
import FirebaseAuth
import UIKit

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesList[indexPath.row]
        print(currentUser?.email)
        if message.sender == currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMessage", for: indexPath) as! MyMessageChatTableViewCell
            cell.labelSenderName.text = currentUser?.displayName
            cell.labelMessage.text = message.text
            cell.labelTime.text = formatDate(message.time)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendMessage", for: indexPath) as! FriendMessageChatTableViewCell
            cell.labelSenderName.text = friendName
            cell.labelMessage.text = message.text
            cell.labelTime.text = formatDate(message.time)
            return cell
        }
    }
    
//    func getNameAccordingToEmail(email: String, completion: @escaping (String?) -> Void) {
//        db.collection("users").document(email).getDocument { (document, error) in
//            if let error = error {
//                print("Error getting document: \(error)")
//                completion(nil)
//            } else if let document = document, document.exists {
//                let friendName = document["name"] as? String ?? "Unknown"
//                completion(friendName)
//            } else {
//                print("Document does not exist")
//                completion(nil)
//            }
//        }
//    }


}
