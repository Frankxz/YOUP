//
//  TestingViewController.swift
//  YOUP
//
//  Created by Robert Miller on 24.11.2021.
//

import UIKit

class TestingViewController: UIViewController {

    @IBOutlet weak var awardsCollectionView: UICollectionView!
    
    @IBOutlet weak var commentsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        awardsCollectionView.delegate = self
        awardsCollectionView.dataSource = self
      
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
    
}

extension TestingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.configure(text: "Skill")
        return cell
    }
}

extension TestingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "Good boy"
        content.secondaryText = "He is a real nice and funny boy!"
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
