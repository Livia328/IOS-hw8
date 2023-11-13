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
            print("myMessage setting...")
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMessage", for: indexPath) as! MyMessageChatTableViewCell
            cell.labelSenderName.text = message.sender
            cell.labelMessage.text = message.text
            cell.labelTime.text = formatDate(message.time)
            return cell
        } else {
            print("friendMessage setting...")
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendMessage", for: indexPath) as! FriendMessageChatTableViewCell
            cell.labelSenderName.text = message.sender
            cell.labelMessage.text = message.text
            cell.labelTime.text = formatDate(message.time)
            return cell
        }
    }

}
