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
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        warningLabel.isHidden = true
        
        mailTextField.setPlaceholder(placeholder: "email@mail.com")
        passOneTextField.setPlaceholder(placeholder: "Password")
        passTwoTextField.setPlaceholder(placeholder: "Confirm password")
        usernameTextField.setPlaceholder(placeholder: "Username")
        nameTextField.setPlaceholder(placeholder: "Name")
        surnameTextField.setPlaceholder(placeholder: "Surname")
    }
    
    
    @IBAction func signUpAction() {
        if checkData() {
            Auth.auth().createUser(withEmail: mailTextField.text!, password: passOneTextField.text!){ [self] user, error in
                
                guard error == nil, user != nil else {
                    showWarning(text: error?.localizedDescription ?? "Unknown errror")
                    return
                }
                
                let youpUser = YoupUser( email: mailTextField.text!,
                                         password: passOneTextField.text!,
                                         name: nameTextField.text!,
                                         surname: surnameTextField.text!,
                                         username: usernameTextField.text!,
                                         image: UIImage(systemName: "circle")!,
                                         id: String((user?.user.uid)!) )
                
                let userRef = ref.child(youpUser.id).child("userInfo")
                FirebaseManager.shared.postUserInfo(youpUser: youpUser)
                
                let statsRef = ref.child(youpUser.id).child("userStats")
                statsRef.setValue(["red" : 0,
                                   "yellow" : 0,
                                   "green" : 0])
                Auth.auth().signIn(withEmail: youpUser.email, password: youpUser.password) { user, error in
                    
                    guard error == nil, user != nil else {
                        showWarning(text: error?.localizedDescription ?? "Unknown errror")
                        return
                    }
                    dismiss(animated: true)
                }
            }
        } else {
            showWarning(text: "Incorrect data :(")
        }
    }
    
    private func showWarning(text: String){
        warningLabel.isHidden = false
        warningLabel.text = "Incorrect data :("
    }
    
    private func checkData() -> Bool {
        mailTextField.text      != nil  &&
        passOneTextField.text   != nil  &&
        passTwoTextField.text   != nil  &&
        usernameTextField.text  != nil  &&
        nameTextField.text      != nil  &&
        surnameTextField.text   != nil  &&
        passOneTextField.text == passTwoTextField.text
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension UITextField {
    func setPlaceholder(placeholder: String){
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
}
