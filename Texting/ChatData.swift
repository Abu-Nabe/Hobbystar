//  MessageData.swift
//  Zinging
//
//  Created by Abu Nabe on 31/3/21.
//

import Foundation
import FirebaseAuth
import ObjectMapper

class ChatData: Mappable {
    
    enum MediaType : String {
        case photo = "Photo"
        case video = "Video"
        case File = "File"
    }
    
    var message: String?
    var receiver: String?
    var messageId: String?
    var seen: Bool?
    var sender: String?
    var mediaUrl: String?
    var mediaType: MediaType?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        receiver <- map["receiver"]
        seen <- map["seen"]
        sender <- map["sender"]
    }
    
    init(receiver: String?, message: String? = nil) {
        self.sender = FirebaseAuth.Auth.auth().currentUser!.uid
        self.message = message
        self.receiver = receiver!
        self.seen = false
    }
}


