//
//  CollectionViewCell.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var awardImage: UIImageView!
    
    func configure(with image: UIImage){
        awardImage.image = image
    }
}
