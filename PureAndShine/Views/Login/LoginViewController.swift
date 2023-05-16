//
//  LoginViewController.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 3.04.2023.
//


import UIKit
import Firebase
final class LoginViewController: BaseViewController{
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        // email ve parola alınması
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        // firebase auth işlemleri
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                // giriş işlemi başarısız oldu
                let alertController = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                // giriş işlemi başarılı oldu
                let alertController = UIAlertController(title: "Başarılı", message: "Giriş işlemi başarıyla tamamlandı!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                // ProfileViewController'a yönlendirme
                let scanVC = ScanViewController()
                navigationController?.pushViewController(scanVC, animated: true)
            }
        }
    }
   
}

