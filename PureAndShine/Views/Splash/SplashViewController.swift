//
//  SplashViewController.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 3.04.2023.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let welcome = WelcomeViewController()
            
        navigationController?.pushViewController(welcome, animated: true)
    }


}

