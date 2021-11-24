//
//  CommentsCollectionFlowLayout.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit

class CommentsCollectionFlowLayout: UICollectionViewFlowLayout {
    private let itemHeight = 340
    private let itemWidth = 260
    
   
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let peekingItemWidth = itemSize.width / 10
        let horizontalInsets = (collectionView.frame.size.width - itemSize.width) / 2 + 10
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: horizontalInsets, bottom: 10, right: horizontalInsets)
        minimumLineSpacing = horizontalInsets - peekingItemWidth
    }
    
}
