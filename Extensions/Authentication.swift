//
//  Auth.swift
//  Zinging
//
//  Created by Abu Nabe on 4/1/21.
//

import FirebaseAuth
import FirebaseDatabase
import Firebase

public class Authentication {
    
    static let shared = Authentication()
    
    
    public func logOut(completion: (Bool) -> Void)
    {
        do{
            try Auth.auth().signOut()
            
            completion(true)
            return
        }catch{
            completion(false)
            print(error)
            return
        }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void)
    {
        //        FirebaseDatabase.Database.database().reference().child("Users").observeSingleEvent(of: .value) { (snapshot) in
        //            guard let value = snapshot.value as? [[String: String]] else {
        //                completion(.failure(DatabaseError.FailedtoFetch))
        //
        //                return
        //            }
        //            completion(.success(value))
        //        }
        FirebaseDatabase.Database.database().reference().child("Users").observe(Firebase.DataEventType.value, with:{(snapshot) in
            for users in snapshot.children.allObjects as![FirebaseDatabase.DataSnapshot] {
                guard let value = users.value as? [[String: String]] else {
                    
                    completion(.failure(DatabaseError.FailedtoFetch))
                    
                    return
                }
                completion(.success(value))
            }
            
        })
    }
    
    public enum DatabaseError: Error{
        case FailedtoFetch
    }
}

