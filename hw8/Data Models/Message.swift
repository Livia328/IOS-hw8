//
//  Message.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/11.
//

import Foundation

struct Message: Codable{
    var sender: String
    var receiever: String
    var text: String
    var time: Date
    
    init(sender: String, receiever: String, text: String, time: Date) {
        self.sender = sender
        self.receiever = receiever
        self.text = text
        self.time = time
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "sender": sender,
            "receiver": receiever,
            "text": text,
            "time": time.timeIntervalSince1970
        ]
    }
}
