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
    let id: String
    let email: String
    let username: String
    let password: String
    
    let name: String
    let surname: String
    var fullname: String { "\(name) \(surname)" }
    
    var aboutme = ""
    var stats: [String : Int] = ["red": 0, "yellow": 0, "green": 0]
    var comments:[Comment] = []
    
    var image = UIImage(systemName: "circle")
    

    var ref: DatabaseReference?
    
    init(user: User){
        id = user.uid
        email = user.email!
        username = ""
        password = ""
        name = ""
        surname = ""
        aboutme = ""
        ref = nil
    }
    
    init(email: String, password: String, name: String, surname: String, username: String, image: UIImage, id: String){
        self.email = email
        self.password = password
        self.name = name
        self.surname = surname
        self.username = username
        self.image = image
        self.id = id
        aboutme = ""
        ref = nil
    }
    
    init(){
        id = ""
        email = ""
        username = ""
        password = ""
        name = ""
        surname = ""
        aboutme = ""
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
