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
    @IBOutlet weak var indicatorView: UIView!
    
    private let commentsCount = 15
    private var currentSelectedIndex = 0 {
        didSet {
            updateSelectedCardIndicator()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        awardsCollectionView.delegate = self
        awardsCollectionView.dataSource = self
        
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        commentsCollectionView.collectionViewLayout = CommentsCollectionFlowLayout()
        
        showIndicatorView()
    }
    
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
        
        let safeIndex = max(0, min(selectedIndex, commentsCount - 1))
        let selectedIndexPath = IndexPath(row: safeIndex, section: 0)
        
        flowLayout.collectionView!.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        
        let previousSelectedIndex = IndexPath(row: Int(currentSelectedIndex), section: 0)
        let previousSelectedCell = commentsCollectionView.cellForItem(at: previousSelectedIndex) as! CommentCollectionViewCell
        let nextSelectedCell = commentsCollectionView.cellForItem(at: selectedIndexPath) as! CommentCollectionViewCell
        
        currentSelectedIndex = selectedIndexPath.row
        
        previousSelectedCell.transformToStandard()
        nextSelectedCell.transformToLarge()
    }
    
    func showIndicatorView() {
        
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for index in 0..<3 {
            let dot = UIImageView(image: UIImage(systemName: "circle.fill"))
            
            dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
            dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
            dot.image = dot.image!.withRenderingMode(.alwaysTemplate)
            dot.tintColor = UIColor.lightGray
            dot.tag = index + 1
            
            if index == currentSelectedIndex {
                dot.tintColor = UIColor.darkGray
            }
            stackView.addArrangedSubview(dot)
        }
        
        indicatorView.subviews.forEach({ $0.removeFromSuperview() })
        indicatorView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor).isActive = true
    }
    
    func updateSelectedCardIndicator() {
        for index in 0...commentsCount - 1 {
            let selectedIndicator: UIImageView? = indicatorView.viewWithTag(index + 1) as? UIImageView
            selectedIndicator?.tintColor = index == currentSelectedIndex ? UIColor.darkGray: UIColor.lightGray
        }
    }

    
}

extension TestingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == awardsCollectionView ? 6 : commentsCount
          
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == awardsCollectionView {
            let cell = awardsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SkillCollectionViewCell
            cell.configure(text: "Skill")
            return cell
        } else
        {
            let cell = commentsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCollectionViewCell
            cell.configure(username: "Gelaseen", fullname: "Robert Miller", avatar: UIImage(systemName: "circle")!,
                           title: "Good guy", text: "He is a real good guy!", type: 1)
            if currentSelectedIndex == indexPath.row {
                cell.transformToLarge()
            }
            return cell
        }
    }
}


