//
//  CollectionViewCell.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit

class SkillCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var miniLabel: UILabel!
    
    func configure(text: String){
        miniLabel.text = text
    }
}
