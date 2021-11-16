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
    var imagesFetchedCounter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        tableView.rowHeight = 60
       
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
            self?.tableView.reloadData()
        }
        imagesFetchedCounter = 0
      
    }
        
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youpUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let youpUser = youpUsers[indexPath.row]
        //fetchImage(youpUser: youpUser)
        content.image = usersImages[youpUser.id] ?? UIImage(systemName: "circle")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.imageProperties.cornerRadius = 25
        
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
    
    func fetchImage(youpUser:  YoupUser) {
        self.imagesFetchedCounter += 1
        self.storageRef = Storage.storage().reference().child("avatars").child(youpUser.id)
        self.storageRef.downloadURL { url, error in
            guard error == nil else { return }
            
            self.storageRef = Storage.storage().reference(forURL: url!.absoluteString)
            let megabyte = Int64(1024 * 1024)
            
            self.storageRef.getData(maxSize: megabyte) { data, error in
                guard let imageData = data else { return }
                print("found image ")
                
                self.usersImages[youpUser.id] = UIImage(data: imageData) ?? UIImage(systemName: "person")
                print("count \(self.youpUsers.count)")
                print("counter \(self.imagesFetchedCounter)")
//                if (self.imagesFetchedCounter < self.youpUsers.count) {
                self.tableView.reloadData()
//                }
            }
        }
    }
}
