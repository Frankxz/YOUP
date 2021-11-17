
//  FireBaseManager.swift
//  YOUP
//
//  Created by Robert Miller on 18.11.2021.
//

import UIKit
import Firebase
import FirebaseStorage

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private init() {}
    
    var databaseRef: DatabaseReference = Database.database().reference(withPath: "users")
    var storageRef: StorageReference!
    
    
    func fetchUser(user: User, complition: @escaping (YoupUser)->()){
        var youpUser: YoupUser!
        
        //Get youpUser
        databaseRef = databaseRef.child(String(user.uid)).child("userInfo")
        databaseRef.observe(.value) { snapshot in
            youpUser = YoupUser(snapshot: snapshot)
            print(youpUser.fullname)
            
            self.databaseRef = Database.database().reference(withPath: "users").child(String(user.uid))
            self.databaseRef.observe(.value) { snapshot in
                var bufferComments: [Comment] = []
                for item in snapshot.childSnapshot(forPath: "comments").children{
                    let comment = Comment(snapshot: item as! DataSnapshot)
                    bufferComments.append(comment)
                }
                youpUser.setStats(snapshot: snapshot)
                youpUser.comments = bufferComments
                complition(youpUser)
            }
        }
    }
}
