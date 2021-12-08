//
//  UsersListViewController.swift
//  YOUP
//
//  Created by Robert Miller on 12.11.2021.
//

import UIKit
import Firebase
import FirebaseStorage
class UsersListViewController: UITableViewController {
    
    var youpUsers: [YoupUser] = []
    var filteredYoupUsers: [YoupUser] = []
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var usersImages: [String : UIImage] = [:]
    var isAllUsersFetched = false
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        ref = Database.database().reference(withPath: "users")
        navigationController?.navigationBar.barTintColor = UIColor(red: 11/255, green: 0, blue: 20/255, alpha: 1)
        tabBarController?.tabBar.barTintColor = UIColor(red: 11/255, green: 0, blue: 20/255, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isAllUsersFetched {
            FirebaseManager.shared.fetchUsers { [self] users in
                youpUsers = users
                for user in youpUsers {
                    FirebaseManager.shared.fetchAvatar(userID: user.id) { image in
                        user.image = image
                        self.tableView.reloadData()
                    }
                }
                
                for (index,user) in youpUsers.enumerated() {
                    if user.id == Auth.auth().currentUser?.uid {
                        youpUsers.remove(at: index)
                        print("deleted me in users list ")
                        filteredYoupUsers = youpUsers
                        tableView.reloadData()
                    }
                }
                
            }
            isAllUsersFetched = true
        }
        
        
        
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredYoupUsers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        
        let youpUser = filteredYoupUsers[indexPath.row]
        
    
        cell.configure(youpUser: youpUser, image: youpUser.image!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userProfileVC = segue.destination as? UserProfileViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let youpUser = filteredYoupUsers[indexPath.row]
        userProfileVC.avatar = youpUser.image
        userProfileVC.youpUser = youpUser
    }
    
}


// MARK: - Work with searchBar logic
extension UsersListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredYoupUsers = []
        
        if searchText == "" { filteredYoupUsers = youpUsers } else {
            for filteredYoupUser in youpUsers {
                if filteredYoupUser.username.lowercased().contains(searchText.lowercased()) || filteredYoupUser.fullname.lowercased().contains(searchText.lowercased()) {
                    filteredYoupUsers.append(filteredYoupUser)
                }
            }
        }
        tableView.reloadData()
    }
}
