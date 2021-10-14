//
//  UserCell.swift
//  YOUP
//
//  Created by Robert Miller on 14.10.2021.
//

import UIKit

class UserCell: UICollectionViewCell {
 
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var greenCounter: UILabel!
    @IBOutlet weak var yellowCounter: UILabel!
    @IBOutlet weak var redCounter: UILabel!
    
    var youpUser: YoupUser!
    
    func configure(with user: YoupUser)  {
        self.youpUser = user
        usernameLabel.text = youpUser.username
        imageView.image = UIImage(named: youpUser.imgName)
        imageView.layer.cornerRadius = imageView.layer.bounds.width/2
        greenCounter.text = String (Int.random(in: 1...20))
        yellowCounter.text = String (Int.random(in: 1...20))
        redCounter.text = String (Int.random(in: 1...20))
    }
    
}
