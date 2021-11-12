//
//  CommentCreatingViewController.swift
//  YOUP
//
//  Created by Robert Miller on 18.10.2021.
//

import UIKit
import Firebase

class CommentCreatingViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentTypeControl: UISegmentedControl!
    @IBOutlet weak var anonSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    
    var ref: DatabaseReference!
    var youpUser: YoupUser!
    var currentFBUser: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentFBUser = Auth.auth().currentUser
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
                               userID: anonSwitch.isOn ? "Unknow user" : "Youp user",
                               type: commentType)
        ref =  Database.database().reference(withPath: "users").child(String(youpUser.id)).child("comments")
        let commmentRef = ref.child(comment1.title.lowercased())
        commmentRef.setValue(["title": comment1.title,
                              "text": comment1.text,
                              "userID": comment1.userID,
                              "type": comment1.type])
        
        dismiss(animated: true)
    }
}
