//
//  ScanViewController.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 16.04.2023.
//

import UIKit
import Photos
import AVFoundation
import Firebase

class ScanViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet private weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }

    
    
    
    @IBAction func selectImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self

           let actionSheet = UIAlertController(title: "Resim Seçin", message: nil, preferredStyle: .actionSheet)

           actionSheet.addAction(UIAlertAction(title: "Fotoğraflarım", style: .default, handler: { (action) in
               let status = PHPhotoLibrary.authorizationStatus()
               if (status == .authorized) {
                   imagePickerController.sourceType = .photoLibrary
                   self.present(imagePickerController, animated: true, completion: nil)
               } else if (status == .denied) {
                   
               } else if (status == .notDetermined) {
                   PHPhotoLibrary.requestAuthorization({ (status) in
                       if (status == .authorized) {
                           imagePickerController.sourceType = .photoLibrary
                           self.present(imagePickerController, animated: true, completion: nil)
                       } else {
                           
                       }
                   })
               } else if (status == .restricted) {
                   
               }
           }))

           actionSheet.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { (action) in
               let status = AVCaptureDevice.authorizationStatus(for: .video)
               if (status == .authorized) {
                   imagePickerController.sourceType = .camera
                   self.present(imagePickerController, animated: true, completion: nil)
               } else if (status == .denied) {
                   
               } else if (status == .notDetermined) {
                   AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                       if (granted) {
                           imagePickerController.sourceType = .camera
                           self.present(imagePickerController, animated: true, completion: nil)
                       } else {
                           
                       }
                   })
               } else if (status == .restricted) {
                   
               }
           }))

           actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))

           self.present(actionSheet, animated: true, completion: nil)
       }
        
    
    @IBAction func profileButton(_ sender: Any) {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    
    
    }



    
   
