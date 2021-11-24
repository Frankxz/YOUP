//
//  CommentsCollectionFlowLayout.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit

class CommentsCollectionFlowLayout: UICollectionViewFlowLayout {
    private let itemHeight = 380
    private let itemWidth = 318
    
   
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let peekingItemWidth = itemSize.width / 10
        let horizontalInsets = (collectionView.frame.size.width - itemSize.width) / 2
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
        minimumLineSpacing = horizontalInsets - peekingItemWidth
    }
    
}
