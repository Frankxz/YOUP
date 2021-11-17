
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
    
    func fetchAvatar(user: User, completion: @escaping (UIImage)->()){
        storageRef = Storage.storage().reference().child("avatars").child(user.uid)
        storageRef.downloadURL { url, error in
            guard error == nil else { return }
            self.storageRef = Storage.storage().reference(forURL: url!.absoluteString)
            let megabyte = Int64(1024 * 1024)
            self.storageRef.getData(maxSize: megabyte) { data, error in
                guard let imageData = data else { return }
                let image =  UIImage(data: imageData) ?? UIImage(systemName: "circle")
                completion(image!)
            }
        }
    }
}
