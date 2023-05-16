//
//  WelcomeViewController.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 3.04.2023.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeImage: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func scanPageButton(_ sender: Any) {
        let scanPage = ScanViewController()
        navigationController?.pushViewController(scanPage, animated: true)
    }

    @IBAction func loginButton(_ sender: Any) {
        let login = LoginViewController()
        navigationController?.pushViewController(login, animated: true)
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let registerTo = RegisterViewController()
        navigationController?.pushViewController(registerTo, animated: true)
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
