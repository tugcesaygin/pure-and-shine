//
//  RegisterViewController.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 3.04.2023.
//

import UIKit
import Firebase

final class RegisterViewController: BaseViewController{
    
    
    @IBOutlet weak var registerImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        // email, parola, ad, soyad ve yaş alınması
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let ad = nameTextField.text,
              let soyad = surnameTextField.text else {
            return
        }
        
        // firebase auth işlemleri
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // kayıt işlemi başarısız oldu
                let alertController = UIAlertController(title: "Hata", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                // kayıt işlemi başarılı oldu
                let alertController = UIAlertController(title: "Başarılı", message: "Kayıt işlemi başarıyla tamamlandı!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                // ek kullanıcı bilgilerini kaydetme işlemi
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "\(ad) \(soyad)"
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Hata: \(error.localizedDescription)")
                        } else {
                            print("Kullanıcı adı kaydedildi: \(user.displayName ?? "")")
                        }
                    }
                    
                    
                }
            }
        }
    }
}
