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
    var image = UIImage(systemName: "person.circle")
    var aboutme = ""
    
    var ref: DatabaseReference?
     var stats: [String : Int] = ["red": 0, "yellow": 0, "green": 0]
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
        id = snapshotValue["id"] as! String
        aboutme = snapshotValue["aboutme"] as! String
        ref = snapshot.ref
    }
    
    init( with snapshot: DataSnapshot) {
        let snapshotValue = snapshot.childSnapshot(forPath: "userInfo").value as! [String: AnyObject]
        email = snapshotValue["email"] as! String
        password = snapshotValue["password"] as! String
        name = snapshotValue["name"] as! String
        surname = snapshotValue["surname"] as! String
        username = snapshotValue["username"] as! String
        id = snapshotValue["id"] as! String
        aboutme = snapshotValue["aboutme"] as! String
        ref = snapshot.ref

    }
    
    func setStats(snapshot: DataSnapshot){
        let snapshotValue = snapshot.childSnapshot(forPath: "userStats").value as! [String: AnyObject]
        stats["red"] = snapshotValue["red"] as? Int
        stats["yellow"] = snapshotValue["yellow"] as? Int
        stats["green"] = snapshotValue["green"] as? Int
        ref = snapshot.ref
    }
}
