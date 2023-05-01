import Firebase

class ZingingData
{
    
    var publisher: String
    var descritpion : String
    var hobby: String
    var timestring : String
    var timestamp = Date().timeIntervalSince1970
    var postimage: String
    
    convenience init(snapshot: DataSnapshot) {
        self.init(id: snapshot.key, value: snapshot.value as! [String : Any])
      }
    init(id: String, value: [String: Any]) {
        self.timestring = id
        self.hobby = value["hobby"] as? String ?? ""
        self.descritpion = value["description"] as? String ?? ""
        self.publisher = value["publisher"] as? String ?? ""
        self.timestamp = value["timestamp"] as? Double ?? 0
        self.postimage = value["postimage"] as? String ?? ""
        
        
   }
}
