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
    
    

    @IBOutlet weak var userInfoStackView: UIStackView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    var currentFBUser: User!
    var youpUser = YoupUser()
    
    var didAvatarChange = true
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _currentFBUser = Auth.auth().currentUser else { return }
        currentFBUser = _currentFBUser
        
        configureWhileLoading()
    
       
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if didAvatarChange {
            FirebaseManager.shared.fetchAvatar(userID: currentFBUser.uid) {
                [self] result in
                configureWhileLoading()
                youpUser.image = result
                profileImg.pulsate()
                profileImg.image = result
                didAvatarChange = false
                print("pek")
                configureWhenLoaded()
            }
        }
        
        FirebaseManager.shared.fetchUser(user: currentFBUser) {
            [self] result in
            print("Дрынкдырынк")
            youpUser = result
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
            cell.backgroundColor = .systemRed
        default:
            cell.backgroundColor = .systemYellow
        }
      
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Work with UI
extension HomeViewController {
    
    func displayUserInfo(){
        navigationItem.title = youpUser.username
        fullnameLabel.text = youpUser.fullname
        redLabel.text = String (youpUser.stats["red"]!)
        yellowLabel.text = String (youpUser.stats["yellow"]!)
        greenLabel.text = String (youpUser.stats["green"]!)
        tableView.reloadData()
    }
    
    func configureWhileLoading() {
        tableView.isHidden = true
        userInfoStackView.isHidden = true
        navigationController?.isNavigationBarHidden = true
      //  view.backgroundColor = .systemGroupedBackground
        
    }
    
    func configureWhenLoaded(){
        displayUserInfo()
        
        tableView.isHidden = false
        userInfoStackView.isHidden = false
        navigationController?.isNavigationBarHidden = false
       // view.backgroundColor = .white
        loadingView.isHidden = true
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

