//
//  ProfileViewController.swift
//  YOUP
//
//  Created by Robert Miller on 09.10.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    var youpUser: YoupUser!
    var ref: DatabaseReference!
    
    let comment1 = Comment(title: "Good guy", text: "I try to understand it", userID: "Unknown", type: 3)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentFBUser = Auth.auth().currentUser else { return }
        
        youpUser = YoupUser(user: currentFBUser)
        ref = Database.database().reference(withPath: "users").child(String(youpUser.id)).child("comments")
    
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 20)
        
        profileImg.image = UIImage(named: "10")
        profileImg.layer.cornerRadius = profileImg.layer.bounds.width/2
        fullnameLabel.text = "Robert Miller"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData();
    }
    func fetchData(){
        
        let commmentRef = ref.child(comment1.title.lowercased())
        commmentRef.setValue(["title": comment1.title,
                              "text": comment1.text,
                              "userID": comment1.userID,
                              "type": comment1.type])
        print("4ETKO")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(named: "avatar2")
        content.imageProperties.cornerRadius = 30
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        content.text = "Alice Miller"
        content.secondaryText = "good boy!"
        cell.contentConfiguration = content
        
        return cell
    }
    
 



}
