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
    
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var yellowLabel: UILabel!
    
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var noCommentsLabel: UILabel!
    
    var youpUser: YoupUser!
    var databaseRef: DatabaseReference!
    var avatar: UIImage!
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.image = avatar
        profileImg.layer.cornerRadius = profileImg.layer.bounds.width/2
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        noCommentsLabel.text = "\(youpUser.username) has no comments yet. Be the first and leave a comment! :)"
        noCommentsLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        databaseRef = Database.database().reference(withPath: "users").child(String(youpUser.id))
        databaseRef.observe(.value) { [weak self] (snapshot) in
            var bufferComments: [Comment] = []
            for item in snapshot.childSnapshot(forPath: "comments").children{
                let comment = Comment(snapshot: item as! DataSnapshot)
                bufferComments.append(comment)
            }
            self?.youpUser.setStats(snapshot: snapshot)
            self?.youpUser.comments = bufferComments
            self?.redLabel.text = String ((self?.youpUser.stats["red"])!)
            self?.yellowLabel.text = String ((self?.youpUser.stats["yellow"])!)
            self?.greenLabel.text = String ((self?.youpUser.stats["green"])!)
            self?.tableView.reloadData()
            if self?.youpUser.comments.count == 0 {
                self?.noCommentsLabel.isHidden = false
            } else {
                self?.noCommentsLabel.isHidden = true
            }
            
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






