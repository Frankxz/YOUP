//
//  ProfileViewController.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.image = UIImage(named: "avatar")
        profileImg.layer.cornerRadius = profileImg.layer.bounds.width/2
        usernameLabel.text = "FurioX"
        fullnameLabel.text = "Robert Miller"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "Sssssss"
        content.secondaryText = "sadsad"
        cell.contentConfiguration = content
        
        return cell
    }
    
 



}
