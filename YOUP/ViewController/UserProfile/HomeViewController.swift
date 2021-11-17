//
//  ProfileViewController.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    
    var currentFBUser: User!
    var youpUser = YoupUser()
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    var didAvatarChange: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _currentFBUser = Auth.auth().currentUser else { return }
        currentFBUser = _currentFBUser
        databaseRef = Database.database().reference(withPath: "users")
        
        
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 20)
        
        profileImg.layer.cornerRadius = profileImg.layer.bounds.width/2
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        FirebaseManager.shared.fetchUser(user: currentFBUser) { youpUser in
            self.youpUser = youpUser
            self.displayUserInfo()
        }
        //        if didAvatarChange { fetchImage() }
        //
        //        databaseRef = Database.database().reference(withPath: "users").child(String(currentFBUser.uid)).child("userInfo")
        //        databaseRef.observe(.value) { [weak self] (snapshot) in
        //            self?.youpUser = YoupUser(snapshot: snapshot)
        //
        //            self?.navigationItem.title = self?.youpUser.username
        //            self?.fullnameLabel.text = self?.youpUser.fullname
        //        }
        //
        //        databaseRef = Database.database().reference(withPath: "users").child(String(currentFBUser.uid))
        //        databaseRef.observe(.value) { [weak self] (snapshot) in
        //            var bufferComments: [Comment] = []
        //            for item in snapshot.childSnapshot(forPath: "comments").children{
        //                let comment = Comment(snapshot: item as! DataSnapshot)
        //                bufferComments.append(comment)
        //            }
        //            self?.youpUser.setStats(snapshot: snapshot)
        //            self?.youpUser.comments = bufferComments
        //            self?.redLabel.text = String ((self?.youpUser.stats["red"])!)
        //            self?.yellowLabel.text = String ((self?.youpUser.stats["yellow"])!)
        //            self?.greenLabel.text = String ((self?.youpUser.stats["green"])!)
        //            self?.tableView.reloadData()
        //
        //        }
        
    }
    
    func displayUserInfo(){
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        
        redLabel.text = String (youpUser.stats["red"]!)
        yellowLabel.text = String (youpUser.stats["yellow"]!)
        greenLabel.text = String (youpUser.stats["green"]!)
        
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        databaseRef.removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.youpUser = youpUser
        settingsVC.imageViewBuff = imageView.image
        settingsVC.delegate = self
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youpUser.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        content.text = youpUser.comments[indexPath.item].title
        content.secondaryText = youpUser.comments[indexPath.item].text
        switch(youpUser.comments[indexPath.item].type) {
        case 0:
            cell.backgroundColor = .systemGreen
        case 2:
            cell.backgroundColor = .systemPink
        default:
            cell.backgroundColor = .systemYellow
        }
        cell.contentConfiguration = content
        
        return cell
    }
    
    func fetchImage(){
        storageRef = Storage.storage().reference().child("avatars").child(currentFBUser.uid)
        storageRef.downloadURL { url, error in
            guard error == nil else { return }
            self.storageRef = Storage.storage().reference(forURL: url!.absoluteString)
            let megabyte = Int64(1024 * 1024)
            self.storageRef.getData(maxSize: megabyte) { data, error in
                guard let imageData = data else { return }
                let image =  UIImage(data: imageData)
                DispatchQueue.main.async(){
                    self.imageView.image = image
                }
                
                print("Ready!")
            }
        }
        didAvatarChange = false
    }
}

protocol FetchImageDelegate {
    func toggleAvatarChangeObserver(isChange: Bool)
}

extension HomeViewController: FetchImageDelegate {
    func toggleAvatarChangeObserver(isChange: Bool) {
        didAvatarChange = isChange
    }
    
}

