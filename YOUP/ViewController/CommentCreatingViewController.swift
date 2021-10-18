//
//  CommentCreatingViewController.swift
//  YOUP
//
//  Created by Robert Miller on 18.10.2021.
//

import UIKit

class CommentCreatingViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentTypeControl: UISegmentedControl!
    @IBOutlet weak var anonSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: SaveCommentDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let comment = Comment(commentType: commentType, comment: textView.text, userId: nil)
        delegate.saveComment(for: comment)
        dismiss(animated: true)
    }
}
