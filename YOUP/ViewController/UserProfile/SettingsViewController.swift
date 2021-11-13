import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SettingsViewController: UIViewController {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    
    var ref: DatabaseReference!
    var youpUser: YoupUser!
    var currentFBUser: User!
    var delegate: FetchImageDelegate!
    
    var imageViewBuff: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.layer.bounds.width / 2 - 10
        guard let _currentFBUser = Auth.auth().currentUser else { return }
        currentFBUser = _currentFBUser
        
        imageView.image = imageViewBuff
        emailTF.text = youpUser.email
        usernameTF.text = youpUser.username
        nameTF.text = youpUser.name
        surnameTF.text = youpUser.surname
        
        // Do any additional setup after loading the view.
    }
    // b d f d b
    
    @IBAction func changeAvatarAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController,animated: true)
    }
    
    func upload(currentUserId: String, photo: UIImage) {
        let ref = Storage.storage().reference().child("avatars").child(currentFBUser.uid)
        
        guard let imgData = imageView.image?.jpegData(compressionQuality: 0.2) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imgData, metadata: metadata) { metadata, error in
            guard let _ = metadata else { return }
            
        }
    }
    
    @IBAction func signOutAction(_ sender: UIButton) {
        
        do {
            print("tapped")
            try Auth.auth().signOut()
            
        }
        catch {
           print(error.localizedDescription)
          
            
        }
        dismiss(animated: true) 
    }
}

extension SettingsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageView.image = image
        upload(currentUserId: currentFBUser.uid, photo: image)
        delegate.toggleAvatarChangeObserver(isChange: true)
    }
}

