//
//  HomePostData.swift
//  Zinging
//
//  Created by Abu Nabe on 7/4/21.
//
import Firebase

class HomePostData
{
    var postimage: String
    var publisher: String
    var timestring : String
    var postID: String
    var timestamp = Date().timeIntervalSince1970
    
    convenience init(snapshot: DataSnapshot) {
        self.init(id: snapshot.key, value: snapshot.value as! [String : Any])
      }
    init(id: String, value: [String: Any]) {
        self.postID = id
        self.timestring = id
        self.publisher = value["publisher"] as? String ?? ""
        self.postimage = value["postimage"] as? String ?? ""
        self.timestamp = value["timestamp"] as? Double ?? 0
        
        
   }
}
