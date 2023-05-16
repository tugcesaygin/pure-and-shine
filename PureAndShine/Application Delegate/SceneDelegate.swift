//
//  SceneDelegate.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 3.04.2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
       
        self.checkAuthentication()
           
    }

    private func setupWindow(with scene : UIScene){
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    public func checkAuthentication(){
        let p = Auth.auth().currentUser
        if Auth.auth().currentUser == nil{
            let wcv = WelcomeViewController()
            let nav = UINavigationController(rootViewController: wcv)
            nav.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = nav
           
        }else{
            let sw = ScanViewController()
            let nav = UINavigationController(rootViewController: sw)
            nav.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = nav
            
        }
    }

}

