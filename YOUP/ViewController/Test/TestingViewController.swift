//
//  TestingViewController.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit

class TestingViewController: UIViewController {

    @IBOutlet weak var awardsCollectionView: UICollectionView!
    
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        awardsCollectionView.delegate = self
        awardsCollectionView.dataSource = self
        
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.collectionViewLayout = CommentsCollectionFlowLayout()
    }
    
}

extension TestingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == awardsCollectionView ? 6 : 5
          
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == awardsCollectionView {
            let cell = awardsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SkillCollectionViewCell
            cell.configure(text: "Skill")
            return cell
        } else {
            let cell = commentsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCollectionViewCell
            cell.configure(username: "Gelaseen", fullname: "Robert Miller", avatar: UIImage(systemName: "circle")!,
                           title: "Good guy", text: "He is a real good guy!", type: 2)
            return cell
        }
    }
}


