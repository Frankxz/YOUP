//
//  UserProfileViewController.swift
//  YOUP
//
//  Created by Robert Miller on 14.10.2021.
//
import UIKit
import Firebase
import FirebaseStorage

class UserProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    var youpUser: YoupUser!
    var databaseRef: DatabaseReference!
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.layer.cornerRadius = profileImg.layer.bounds.width/2
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        databaseRef = Database.database().reference(withPath: "users").child(String(youpUser.id)).child("comments")

        databaseRef.observe(.value) { [weak self] (snapshot) in
            var bufferComments: [Comment] = []
            for item in snapshot.children {
                let comment = Comment(snapshot: item as! DataSnapshot)
                bufferComments.append(comment)
            }
            
            self?.youpUser.comments = bufferComments
            self?.tableView.reloadData()
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let commentCreatingVC = segue.destination as! CommentCreatingViewController
        commentCreatingVC.youpUser = youpUser
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youpUser.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let comment = youpUser.comments[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = comment.title
        content.secondaryText = comment.text
        
        switch(comment.type) {
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
    
}






