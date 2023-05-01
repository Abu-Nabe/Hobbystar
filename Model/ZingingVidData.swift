import Firebase

class ZingingVidData
{
    
    var publisher: String
    var timestring : String
    var timestamp = Date().timeIntervalSince1970
    var picimage: String
    var picid: String
    
    
    convenience init(snapshot: DataSnapshot) {
        self.init(id: snapshot.key, value: snapshot.value as! [String : Any])
      }
    init(id: String, value: [String: Any]) {
        self.timestring = id
        self.publisher = value["videoPublisher"] as? String ?? ""
        self.timestamp = value["timestamp"] as? Double ?? 0
        self.picid = value["videoID"] as? String ?? ""
        self.picimage = value["videoUrl"] as? String ?? ""
   }
}
