//
//  Contact.swift
//  hw8
//
//  Created by 陈可轩 on 2023/11/9.
//

import Foundation

struct Contact: Codable{
    var name: String
    var email: String
    var phone: Int
    
    init(name: String, email: String, phone: Int) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
