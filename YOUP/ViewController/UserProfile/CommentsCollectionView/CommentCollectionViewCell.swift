//
//  CommentCollectionViewCell.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var separatorView: UIView!
    

func configure(username: String,fullname: String, avatar: UIImage, title: String, text: String, type: Int){
    usernameLabel.text = username
    fullnameLabel.text = fullname
    avatarImage.image = avatar
    
    commentTitleLabel.text = title
    commentTextLabel.text = text
    
    switch(type){
    case 0:
        setHeaderColor(color: .systemGreen)
    case 1:
        setHeaderColor(color: .systemYellow)
    default:
        setHeaderColor(color: .systemPink)
    }
}
    func setHeaderColor(color: UIColor){
        headerView.backgroundColor = color
        separatorView.backgroundColor = color
    }
}

extension CommentCollectionViewCell {
    
    func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    func transformToStandard() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}

