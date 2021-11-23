//
//  UserTableViewCell.swift
//  YOUP
//
//  Created by Robert Miller on 17.11.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
 
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameTF: UILabel!
    @IBOutlet weak var fullnameTF: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(youpUser: YoupUser,image: UIImage){
        avatarImage.image = image
        usernameTF.text = youpUser.username
        fullnameTF.text = youpUser.fullname
    }

}
