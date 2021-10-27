//
//  UserProfileViewController.swift
//  YOUP
//
//  Created by Robert Miller on 14.10.2021.
//
import UIKit

class UserProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    let cellReuseIdentifier = "cell"
    var youpUser: YoupUser!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.image = UIImage(named: youpUser.imgName)
        profileImg.layer.cornerRadius = profileImg.layer.bounds.width/2
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let commentCreatingVC = segue.destination as! CommentCreatingViewController
        commentCreatingVC.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        youpUser.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let comment = youpUser.comments[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = comment.userID ?? "Anonymous author"
        content.secondaryText = comment.text
        
        cell.contentConfiguration = content
        switch(comment.type) {
        case 0:
            cell.backgroundColor = .green
        case 2:
            cell.backgroundColor = .red
        default:
            cell.backgroundColor = .orange
        }
        
        return cell
    }
    
}
    protocol SaveCommentDelegate{
        func saveComment(for comment: Comment)
    }

    extension UserProfileViewController: SaveCommentDelegate {
        func saveComment(for comment: Comment) {
            youpUser.comments.append(comment)
            tableView.reloadData()
        }
    }





