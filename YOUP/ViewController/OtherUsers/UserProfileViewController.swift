//
//  UserProfileViewController.swift
//  YOUP
//
//  Created by Robert Miller on 14.10.2021.
//
import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var commentCounterLabel: UILabel!
    @IBOutlet weak var aboutmeLabel: UILabel!
    @IBOutlet weak var aboutmeTextLabel: UILabel!
    @IBOutlet weak var commentAdviceLabel: UILabel!
    
    var avatar: UIImage!
    var youpUser = YoupUser()
    
    private var currentSelectedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 11/255, green: 0, blue: 20/255, alpha: 1)
        
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.collectionViewLayout = CommentsCollectionFlowLayout()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // configureWhileLoading()
        
        FirebaseManager.shared.fetchAvatar(userID: youpUser.id) {
            [self] result in
            youpUser.image = result
            avatarImageView.image = youpUser.image
        }
        
        FirebaseManager.shared.fetchUser(id: youpUser.id) {
            [self] result in
            youpUser = result
            configureWhenLoaded()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let commentCreatingVC = segue.destination as? CommentCreatingViewController else { return }
        commentCreatingVC.youpUser = youpUser
    }
    
}

//MARK: - skillsCollectionView and commentsCollectionView
extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        youpUser.comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = commentsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCollectionViewCell
        let comment = youpUser.comments[indexPath.item]
        cell.configure(username: comment.authorUsername,
                       fullname: comment.authorFullname,
                       avatar: comment.authorImage!,
                       title: comment.title, text: comment.text, type: comment.type)
        if currentSelectedIndex == indexPath.row { cell.transformToLarge() }
        return cell
    }
    
}


// MARK: - Work with UI
extension UserProfileViewController {
    
    func displayUserInfo(){
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        setAboutme()
        
        redLabel.text = String (youpUser.stats["red"]!)
        yellowLabel.text = String (youpUser.stats["yellow"]!)
        greenLabel.text = String (youpUser.stats["green"]!)
        
        commentCounterLabel.text = "\(youpUser.comments.count) comments"
        commentAdviceLabel.text = "Do you know \(youpUser.name)? Write what you think about him!"
        
        commentsCollectionView.reloadData()
    }
    
    func setAboutme(){
        if youpUser.aboutme == "" {
            aboutmeTextLabel.text = "\(youpUser.name) has not yet posted information about himself 😢"
            aboutmeTextLabel.textColor = .gray
        } else {
            aboutmeTextLabel.textColor = .white
            aboutmeTextLabel.text = youpUser.aboutme
            aboutmeLabel.text = "About \(youpUser.name)"
        }
    }
    
    func configureWhileLoading() {
        navigationController?.isNavigationBarHidden = true
        self.scrollView.isScrollEnabled = false
        
    }
    
    func configureWhenLoaded(){
        navigationController?.isNavigationBarHidden = false
        self.scrollView.isScrollEnabled = true
        
        displayUserInfo()
    }
}



// MARK: - Comments card logic
extension UserProfileViewController {
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
