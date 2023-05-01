//
//  PostNotif.swift
//  Zinging
//
//  Created by Abu Nabe on 20/3/21.
//

import Firebase

class PostNotif
{
    var post: String
    var description: String
    var publisher: String
    var timestring: String
    var timestamp = Date().timeIntervalSince1970
    var posttype: String
    
    convenience init(snapshot: DataSnapshot) {
        self.init(id: snapshot.key, value: snapshot.value as! [String : Any])
      }
    init(id: String, value: [String: Any]) {
        self.post = value["post"] as? String ?? ""
        self.timestring = id
        self.publisher = value["publisher"] as? String ?? ""
        self.posttype = value["posttype"] as? String ?? ""
        self.timestamp = value["timestamp"] as? Double ?? 0
        self.description = value["description"] as? String ?? ""
        
        
        
   }
}
