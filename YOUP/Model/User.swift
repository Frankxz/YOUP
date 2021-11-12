//
//  User.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import Foundation
import Firebase
import FirebaseAuth

class YoupUser {
    var username = ""
    var name = ""
    var surname = ""
    var password = ""
    var imgName = ""
    
    let ref: DatabaseReference?
  //  var stats: [Int] = []
     let id: String
     let email: String

    var fullname: String { "\(name) \(surname)" }
    
    var comments:[Comment] = []
    
    init(user: User){
        id = user.uid
        email = user.email!
        ref = nil
    }
    
    init(email: String, password: String, name: String, surname: String, username: String, imgName: String, id: String){
        self.email = email
        self.password = password
        self.name = name
        self.surname = surname
        self.username = username
        self.imgName = imgName
        self.id = id
        ref = nil
    }
    
    init(){
        email = ""
        id = ""
        ref = nil
    }

    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        password = snapshotValue["password"] as! String
        name = snapshotValue["name"] as! String
        surname = snapshotValue["surname"] as! String
        username = snapshotValue["username"] as! String
      //  imgName = snapshotValue["imgName"] as! String
        id = snapshotValue["id"] as! String
        ref = snapshot.ref
    }
    
    init( with snapshot: DataSnapshot) {
        let snapshotValue = snapshot.childSnapshot(forPath: "userInfo").value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        password = snapshotValue["password"] as! String
        name = snapshotValue["name"] as! String
        surname = snapshotValue["surname"] as! String
        username = snapshotValue["username"] as! String
      //  imgName = snapshotValue["imgName"] as! String
        id = snapshotValue["id"] as! String
        ref = snapshot.ref

    }
    
}

