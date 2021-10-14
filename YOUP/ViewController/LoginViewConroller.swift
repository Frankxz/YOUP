//
//  ViewController.swift
//  YOUP
//
//  Created by Robert Miller on 29.09.2021.
//

import UIKit
import Firebase

class LoginViewConroller: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var incorrectDataLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!

    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "enterSignIn", sender: nil)
            }
            else{
                return
            }
        }
    }
    
    
    
    @IBAction func loginAction() {
        Auth.auth().signIn(withEmail: usernameTF.text!,
                           password: passwordTF.text!) { user, error in
            if error != nil {
                self.warningLabel.isHidden = false
                self.warningLabel.text = error?.localizedDescription
                return
            }
            if user != nil {
                
                self.performSegue(withIdentifier: "enterSignIn", sender: nil)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    //Work with keyboard
    @objc func kbDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width,
                                                        height: self.view.bounds.size.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                        left: 0,
                                                                        bottom: kbFrameSize.height,
                                                                        right: 0)
      
    }
    
    @objc func kbDidHide(){
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width,
                                                        height: self.view.bounds.size.height)
        
    }
    

}

