//
//  Chat.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/11.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Codable{
    @DocumentID var id: String?
    var participants: [String]
    var messages: [Message]
    
    init(participants: [String]) {
        self.participants = participants
        self.messages = []
    }
}
