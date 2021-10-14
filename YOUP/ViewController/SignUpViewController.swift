//
//  SignUpViewController.swift
//  YOUP
//
//  Created by Robert Miller on 30.09.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    private var ref: DatabaseReference!
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passOneTextField: UITextField!
    @IBOutlet weak var passTwoTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        warningLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpAction() {
        if mailTextField.text != nil &&
            passOneTextField.text != nil && passTwoTextField.text != nil &&
            passOneTextField.text == passTwoTextField.text {
            Auth.auth().createUser(withEmail: mailTextField.text!,
                                   password: passOneTextField.text!) { user, error in
                if error != nil {
                    self.warningLabel.isHidden = false
                    self.warningLabel.text = error?.localizedDescription
                    return
                }
                if user != nil {
                    let userRef = self.ref?.child((user?.user.uid)!)
                    userRef?.setValue(["email": user?.user.email])
                }
            }
        } else {
            self.warningLabel.isHidden = false
            warningLabel.text = "Incorrect data :("
        }
            
    }
    
   

}
