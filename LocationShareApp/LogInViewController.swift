import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "Map", sender: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func register() {
        if let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error == nil {
                    Firestore.firestore().collection("users").document(result!.user.uid).setData([
                        "uid": result!.user.uid,
                        "email": email,
                        "latitude": self.appDelegate.locationManager.location!.coordinate.latitude,
                        "longitude": self.appDelegate.locationManager.location!.coordinate.longitude,
                    ], merge: true) { _ in
                        let alert = UIAlertController(title: "アカウント作成", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.performSegue(withIdentifier: "Map", sender: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
