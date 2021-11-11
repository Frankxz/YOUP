//
//  Comment.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import Foundation
import Firebase
import FirebaseDatabase

enum CommentType {
    case good
    case neutral
    case bad
}

class Comment {
    let title: String
    let text: String
    let userID: String
    let type: Int
    let ref: DatabaseReference?
    
    
    init(title: String, text: String, userID: String, type: Int){
        self.title = title
        self.text = text
        self.userID = userID
        self.type = type
        ref = nil
    }
    
    init(snapshot:DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        text = snapshotValue["text"] as! String
        userID = snapshotValue["userID"] as! String
        type = snapshotValue["type"] as! Int
        ref = snapshot.ref
    }
}
