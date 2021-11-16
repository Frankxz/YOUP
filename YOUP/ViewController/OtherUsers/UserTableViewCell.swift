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
    @IBOutlet weak var commentsCountTF: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
