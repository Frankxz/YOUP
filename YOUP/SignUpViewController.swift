//
//  SignUpViewController.swift
//  YOUP
//
//  Created by Robert Miller on 30.09.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passOneTextField: UITextField!
    
    @IBOutlet weak var passTwoTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    self.performSegue(withIdentifier: "enterSignUp", sender: nil)
                }
            }
        } else {
            self.warningLabel.isHidden = false
            warningLabel.text = "Incorrect data :("
        }
            
    }
    
   

}
