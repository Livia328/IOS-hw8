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
        let reuseIdentifier: String
        if message.sender == currentUser?.email {
            reuseIdentifier = "myMessage"
        } else {
            reuseIdentifier = "friendMessage"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UITableViewCell
        return cell
    }
}
