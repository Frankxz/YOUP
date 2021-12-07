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
    @IBOutlet weak var aboutmeTextView: UITextView!
    @IBOutlet weak var commentAdviceLabel: UILabel!
    
    var avatar: UIImage!
    
    var youpUser = YoupUser()
    
    private let commentsCount = 15
    private var currentSelectedIndex = 0

    var didAvatarChange = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 11/255, green: 0, blue: 20/255, alpha: 1)
        
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.collectionViewLayout = CommentsCollectionFlowLayout()
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        configureWhileLoading()
        if didAvatarChange {
            FirebaseManager.shared.fetchAvatar(userID: youpUser.id) {
                [self] result in
                youpUser.image = result
                avatarImageView.image = result
                didAvatarChange = false
                print("pek")
                
            }
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
                       avatar: UIImage(systemName: "questionmark.circle")!,
                           title: comment.title, text: comment.text, type: comment.type)
            if currentSelectedIndex == indexPath.row { cell.transformToLarge() }
            return cell
        }
    
}


// MARK: - Work with UI
extension UserProfileViewController {
    
    func displayUserInfo(){
        if(youpUser.comments.count == 0) {
            commentsCollectionView.isHidden = true
        }
        else {
            commentsCollectionView.isHidden = false
        }
        
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        redLabel.text = String (youpUser.stats["red"]!)
        yellowLabel.text = String (youpUser.stats["yellow"]!)
        greenLabel.text = String (youpUser.stats["green"]!)
        commentCounterLabel.text = "\(youpUser.comments.count) comments"
        setAboutme()
        commentAdviceLabel.text = "Do you know \(youpUser.name)? Write what you think about him!"
        commentsCollectionView.reloadData()
    }
    
    func setAboutme(){
        aboutmeTextView.text = youpUser.aboutme
        aboutmeLabel.text = "    About \(youpUser.name)"
        if youpUser.aboutme == "" {
            aboutmeLabel.isHidden = true
            aboutmeTextView.isHidden = true
        } else {
            aboutmeLabel.isHidden = false
            aboutmeTextView.isHidden = false
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
