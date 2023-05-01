//
//  SubChat.swift
//  Zinging
//
//  Created by Abu Nabe on 19/1/21.
//

import UIKit

struct SubChat {
    
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension SubChat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
