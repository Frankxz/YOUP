//
//  UsersListViewController.swift
//  YOUP
//
//  Created by Robert Miller on 12.11.2021.
//

import UIKit
import Firebase

class UsersListViewController: UITableViewController {

    var youpUsers: [YoupUser] = []
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference(withPath: "users")
        ref.observe(.value) { [weak self] (snapshot) in
            print("Im here")
            var bufferYoupUsers: [YoupUser] = []
            for child in snapshot.children {
                let youpUser = YoupUser(with: child as! DataSnapshot)
                bufferYoupUsers.append(youpUser)
            }
            self?.youpUsers = bufferYoupUsers
            self?.tableView.reloadData()
            print(bufferYoupUsers.count)
        }
        
    }
        
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youpUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let youpUser = youpUsers[indexPath.row]
        content.image = UIImage(named: "plug")
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        content.imageProperties.cornerRadius = 20
        
        content.text = youpUser.username
        content.secondaryText = youpUser.fullname
        cell.contentConfiguration = content
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userProfileVC = segue.destination as? UserProfileViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let youpUser = youpUsers[indexPath.row]
        userProfileVC.youpUser = youpUser
    }

}
