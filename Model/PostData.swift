//
//  PostData.swift
//  Zinging
//
//  Created by Abu Nabe on 21/1/21.
//

import UIKit
import Firebase

struct PostData
{
    var postimage: String
    var publisher: String
    var timestring : String
    var timestamp = Date().timeIntervalSince1970
}

class AllPostData
{
    var postid: String
    var postimage: String
    var publisher: String
    var timestring : String
    var timestamp =  Date().timeIntervalSince1970
    var hobby: String
    var description: String
    
    convenience init(snapshot: DataSnapshot) {
        self.init(id: snapshot.key, value: snapshot.value as! [String : Any])
      }
    init(id: String, value: [String: Any]) {
        self.postid = value["picid"] as? String ?? ""
        self.timestring = id
        self.hobby = value["hobby"] as? String ?? ""
        self.publisher = value["publisher"] as? String ?? ""
        self.postimage = value["picimage"] as? String ?? ""
        self.timestamp = value["timestamp"] as? Double ?? 0
        self.description = value["description"] as? String ?? ""
   }
    
}

class AllVideoData
{
    var videoid: String
    var videoimage: String
    var publisher: String
    var timestring : String
    var timestamp =  Date().timeIntervalSince1970
    var hobby: String
    var description: String
    
    convenience init(snapshot: DataSnapshot) {
        self.init(id: snapshot.key, value: snapshot.value as! [String : Any])
      }
    init(id: String, value: [String: Any]) {
        self.videoid = value["videoID"] as? String ?? ""
        self.timestring = id
        self.hobby = value["videoHobby"] as? String ?? ""
        self.publisher = value["videoPublisher"] as? String ?? ""
        self.videoimage = value["videoUrl"] as? String ?? ""
        self.timestamp = value["timestamp"] as? Double ?? 0
        self.description = value["videoName"] as? String ?? ""
        
   }
    
}

class FPPost {
  var postID: String

  convenience init(snapshot: DataSnapshot) {
    self.init(id: snapshot.key, value: snapshot.value as! [String : Any])
  }

  init(id: String, value: [String: Any]) {
    self.postID = id
  }

}


extension FPPost: Equatable {
  static func ==(lhs: FPPost, rhs: FPPost) -> Bool {
    return lhs.postID == rhs.postID
  }
}

