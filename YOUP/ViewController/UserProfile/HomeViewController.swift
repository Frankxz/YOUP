//
//  ProfileViewController.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    var currentFBUser: User!
    var youpUser = YoupUser()
    var ref: DatabaseReference!
    
    let comment1 = Comment(title: "Good guy", text: "I try to understand it", userID: "Unknown", type: 3)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _currentFBUser = Auth.auth().currentUser else { return }
        currentFBUser = _currentFBUser
        
        ref = Database.database().reference(withPath: "users")
        print("REFERENCE: " )
    
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 20)
        
        profileImg.layer.cornerRadius = profileImg.layer.bounds.width/2
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference(withPath: "users").child(String(currentFBUser.uid)).child("userInfo")
        ref.observe(.value) { [weak self] (snapshot) in
            self?.youpUser = YoupUser(snapshot: snapshot)
            
            self?.navigationItem.title = self?.youpUser.username
            self?.fullnameLabel.text = self?.youpUser.fullname
        }
        
        ref = Database.database().reference(withPath: "users").child(String(currentFBUser.uid)).child("comments")

        ref.observe(.value) { [weak self] (snapshot) in
            var bufferComments: [Comment] = []
            for item in snapshot.children {
                let comment = Comment(snapshot: item as! DataSnapshot)
                bufferComments.append(comment)
            }
            
            self?.youpUser.comments = bufferComments
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        ref.removeAllObservers()
    }
    
    func fetchData(){
        ref = Database.database().reference(withPath: "users").child(String(currentFBUser.uid)).child("comments")
        let commmentRef = ref.child(comment1.title.lowercased())
        commmentRef.setValue(["title": comment1.title,
                              "text": comment1.text,
                              "userID": comment1.userID,
                              "type": comment1.type])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youpUser.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
       
        content.image = UIImage(named: "avatar2")
        content.imageProperties.cornerRadius = 30
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        content.text = youpUser.comments[indexPath.item].title
        content.secondaryText = youpUser.comments[indexPath.item].text
        cell.contentConfiguration = content
        
        return cell
    }
}

