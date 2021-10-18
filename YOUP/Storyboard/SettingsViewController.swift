import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutAction(_ sender: UIButton) {
        
        do {
            print("tapped")
           try Auth.auth().signOut()
            
        }
        catch {
           print(error.localizedDescription)
          
            
        }
    }
}
