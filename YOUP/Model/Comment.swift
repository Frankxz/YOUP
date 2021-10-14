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

    let text: String
    let userID: String?
    let ref: DatabaseReference?
    
    init(commentType: CommentType, comment: String, userId: String?){
        userID = userId
        text = comment
      //  type = commentType
        ref = nil
    }
    
    init(snapshot:DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        userID = snapshotValue["userID"] as? String
        text = snapshotValue["text"] as! String
        ref = snapshot.ref
        
    }
}
