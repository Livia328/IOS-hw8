//
//  ContactsTableViewManager.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/9.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewContactsID, for: indexPath) as! ContactsTableViewCell
        let participants = chatsList[indexPath.row].participants
        
        
        // cell.labelName.text = chatsList[indexPath.row].name
        return cell
    }
}
