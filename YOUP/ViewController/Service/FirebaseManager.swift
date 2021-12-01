
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
    
    let usersRef = Database.database().reference(withPath: "users")
    var databaseCurrentRef: DatabaseReference!
    var storageRef: StorageReference!
    
    
    func fetchUser(user: User, complition: @escaping (YoupUser)->()){
        var youpUser: YoupUser!
        
        //Get youpUser
        databaseCurrentRef = usersRef.child(String(user.uid)).child("userInfo")
        databaseCurrentRef.observe(.value) { snapshot in
            youpUser = YoupUser(snapshot: snapshot)
            
            
            self.databaseCurrentRef = self.usersRef.child(String(user.uid))
            self.databaseCurrentRef.observe(.value) { snapshot in
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
    
    func fetchAvatar(userID: String, completion: @escaping (UIImage)->()){
        storageRef = Storage.storage().reference().child("avatars").child(userID)
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
    
    func fetchUsers(completion: @escaping ([YoupUser])->() ){
        usersRef.observe(.value) { (snapshot) in
            print("Im here")
            var bufferYoupUsers: [YoupUser] = []
            print("Im here 1")
            for child in snapshot.children {
                print("Im there")
                let youpUser = YoupUser(with: child as! DataSnapshot)
                bufferYoupUsers.append(youpUser)
            }
            
            completion(bufferYoupUsers)
        }
    }
    
    func postUserInfo(youpUser: YoupUser){
        databaseCurrentRef = usersRef.child(String(youpUser.id)).child("userInfo")
        databaseCurrentRef.setValue(["email": youpUser.email,
                                     "id": youpUser.id,
                                     "password": youpUser.password,
                                     "username": youpUser.username,
                                     "name": youpUser.name,
                                     "surname": youpUser.surname,
                                     "aboutme": youpUser.aboutme])
    }
}
