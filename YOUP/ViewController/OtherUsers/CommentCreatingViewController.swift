//
//  CommentCreatingViewController.swift
//  YOUP
//
//  Created by Robert Miller on 18.10.2021.
//

import UIKit
import Firebase

class CommentCreatingViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleSeparatorView: UIView!
    @IBOutlet weak var authorUsernameLabel: UILabel!
    
    @IBOutlet weak var authorFullnameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentTypeControl: UISegmentedControl!
    @IBOutlet weak var anonSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    
    var ref: DatabaseReference!
    var youpUser: YoupUser!
    var currentFBUser: User!
    var author: YoupUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textColor = .white
        currentFBUser = Auth.auth().currentUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseManager.shared.fetchUser(id: currentFBUser.uid) { user in
            self.author = user
        }
    }
    
    @IBAction func changeType() {
        switch(commentTypeControl.selectedSegmentIndex){
        case 0:
            titleView.backgroundColor = .systemGreen
            titleSeparatorView.backgroundColor = .systemGreen
        case 2:
            titleView.backgroundColor = .systemPink
            titleSeparatorView.backgroundColor = .systemPink
        default:
            titleView.backgroundColor = .systemYellow
            titleSeparatorView.backgroundColor = .systemYellow
        }
    }
    
    @IBAction func addCommentAction() {
        let commentType: Int
        switch(commentTypeControl.selectedSegmentIndex){
        case 0:
            commentType = 0
        case 2:
            commentType = 2
        default:
            commentType = 1
        }
        let comment1 = Comment(title: titleTextField.text ?? "Comment",
                               text: textView.text,
                               userID: anonSwitch.isOn ? "Youp user" : Auth.auth().currentUser?.uid as! String ,
                               type: commentType,
                               authorUsername: anonSwitch.isOn ? "" :  author.username,
                               authorFullname: anonSwitch.isOn ? "" : author.fullname)
        
        ref =  Database.database().reference(withPath: "users").child(String(youpUser.id)).child("comments")
        let commmentRef = ref.child(comment1.title.lowercased())
        commmentRef.setValue(["title": comment1.title,
                              "text": comment1.text,
                              "userID": comment1.userID,
                              "type": comment1.type,
                              "authorUsername": comment1.authorUsername,
                              "authorFullname": comment1.authorFullname])
        var commentType_: String!
        //var stats: [String: Int]!
        if(commentType == 0) {
            commentType_ = "green"
        } else if (commentType == 2){
            commentType_ = "red"
        } else {
            commentType_ = "yellow"
        }
        ref = Database.database().reference(withPath: "users").child(String(youpUser.id))
        
        
        ref = Database.database().reference(withPath: "users").child(String(youpUser.id)).child("userStats")
        youpUser.stats[commentType_]!+=1
        ref.setValue(["red" : youpUser.stats["red"],
                      "yellow" : youpUser.stats["yellow"],
                      "green" : youpUser.stats["green"]])
        print("set stats")
        
        
        
        dismiss(animated: true)
    }
    
    
    
    @IBAction func switchAction() {
        if anonSwitch.isOn {
            authorUsernameLabel.text = "Somebody"
            authorFullnameLabel.text = "Unknown who 🙄"
        } else {
            authorUsernameLabel.text = author.username
            authorFullnameLabel.text = author.fullname
        }
    }
    
}
