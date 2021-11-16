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
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var usersImages: [String : UIImage] = [:]
  
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
            
            for user in self!.youpUsers {
                self?.fetchImage(youpUser: user)
            }
            
        }
      
    }
        
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youpUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
       
        let youpUser = youpUsers[indexPath.row]
        let avatarImage = usersImages[youpUser.id] ?? UIImage(systemName: "person.circle")
        cell.configure(youpUser: youpUser,
                       image: avatarImage!)
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let userProfileVC = segue.destination as? UserProfileViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let youpUser = youpUsers[indexPath.row]
        let image = usersImages[youpUser.id] ?? UIImage(systemName: "person.circle")
        userProfileVC.avatar = image
        userProfileVC.youpUser = youpUser
    }
    
    func fetchImage(youpUser:  YoupUser) {

        self.storageRef = Storage.storage().reference().child("avatars").child(youpUser.id)
        self.storageRef.downloadURL { url, error in
            guard error == nil else { return }
            
            self.storageRef = Storage.storage().reference(forURL: url!.absoluteString)
            let megabyte = Int64(1024 * 1024)
            
            self.storageRef.getData(maxSize: megabyte) { data, error in
                guard let imageData = data else { return }
                print("found image ")
                
                self.usersImages[youpUser.id] = UIImage(data: imageData) ?? UIImage(systemName: "person")
                self.tableView.reloadData()
                print("Data reload")
            }
        }
    }
}
