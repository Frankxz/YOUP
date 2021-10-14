//
//  MainCollectionViewController.swift
//  YOUP
//
//  Created by Robert Miller on 12.10.2021.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    var users = YoupUser.getUsersList()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
        }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        let user = users[indexPath.item]
        cell.configure(with: user)
        return cell
    }

}
