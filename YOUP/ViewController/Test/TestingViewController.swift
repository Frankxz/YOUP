//
//  TestingViewController.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit
import Firebase

class TestingViewController: UIViewController {

    
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var commentCounterLabel: UILabel!
    @IBOutlet weak var aboutmeTextView: UITextView!
    
    var currentFBUser: User!
    var youpUser = YoupUser()
    
    private let commentsCount = 15
    private var currentSelectedIndex = 0

    var didAvatarChange = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _currentFBUser = Auth.auth().currentUser else { return }
        currentFBUser = _currentFBUser
        navigationController?.navigationBar.barTintColor = UIColor(red: 11/255, green: 0, blue: 20/255, alpha: 1)
        skillsCollectionView.delegate = self
        skillsCollectionView.dataSource = self
        
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.collectionViewLayout = CommentsCollectionFlowLayout()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if didAvatarChange {
            FirebaseManager.shared.fetchAvatar(userID: currentFBUser.uid) {
                [self] result in
               // configureWhileLoading()
                youpUser.image = result
                avatarImageView.image = result
                didAvatarChange = false
                print("pek")
                //configureWhenLoaded()
                displayUserInfo()
            }
        }
        
        FirebaseManager.shared.fetchUser(user: currentFBUser) {
            [self] result in
            print("Дрынкдырынк")
            youpUser = result
        }
    
    }
   
}

//MARK: - skillsCollectionView and commentsCollectionView
extension TestingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == skillsCollectionView ? 6 : youpUser.comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == skillsCollectionView {
            let cell = skillsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SkillCollectionViewCell
            cell.configure(text: "Skill")
            return cell
        }
        
        else {
            let cell = commentsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCollectionViewCell
            let comment = youpUser.comments[indexPath.item]
            cell.configure(username: "Somebody", fullname: "Somebody",
                           avatar: UIImage(systemName: "questionmark.circle")!,
                           title: comment.title, text: comment.text, type: comment.type)
            if currentSelectedIndex == indexPath.row { cell.transformToLarge() }
            return cell
        }
    }
    
}

// MARK: - Work with UI
extension TestingViewController {
    
    func displayUserInfo(){
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        redLabel.text = String (youpUser.stats["red"]!)
        yellowLabel.text = String (youpUser.stats["yellow"]!)
        greenLabel.text = String (youpUser.stats["green"]!)
        skillsCollectionView.reloadData()
        commentsCollectionView.reloadData()
    }
}

extension TestingViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentCell = commentsCollectionView.cellForItem(at: IndexPath(row: currentSelectedIndex, section: 0)) as! CommentCollectionViewCell
        currentCell.transformToStandard()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard scrollView == commentsCollectionView else {
            return
        }
        
        targetContentOffset.pointee = scrollView.contentOffset
        
        let flowLayout = commentsCollectionView.collectionViewLayout as! CommentsCollectionFlowLayout
        let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let horizontalVelocity = velocity.x
        
        var selectedIndex =  currentSelectedIndex
        
        switch horizontalVelocity {
        // On swiping
        case _ where horizontalVelocity > 0 :
            selectedIndex = currentSelectedIndex + 1
        case _ where horizontalVelocity < 0:
            selectedIndex = currentSelectedIndex - 1
            
        // On dragging
        case _ where horizontalVelocity == 0:
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)
            
            selectedIndex = Int(roundedIndex)
        default:
            print("Incorrect velocity for collection view")
        }
        
        let safeIndex = max(0, min(selectedIndex, youpUser.comments.count - 1))
        let selectedIndexPath = IndexPath(row: safeIndex, section: 0)
        
        flowLayout.collectionView!.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        
        let previousSelectedIndex = IndexPath(row: Int(currentSelectedIndex), section: 0)
        let previousSelectedCell = commentsCollectionView.cellForItem(at: previousSelectedIndex) as! CommentCollectionViewCell
        let nextSelectedCell = commentsCollectionView.cellForItem(at: selectedIndexPath) as! CommentCollectionViewCell
        
        currentSelectedIndex = selectedIndexPath.row
        
        previousSelectedCell.transformToStandard()
        nextSelectedCell.transformToLarge()
    }
    
}


