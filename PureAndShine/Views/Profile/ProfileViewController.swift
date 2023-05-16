//
//  ProfileViewController.swift
//  PureAndShine
//
//  Created by Tuğçe Saygın on 15.05.2023.
//

import UIKit
import FirebaseStorage
import SDWebImage
import FirebaseAuth
import Firebase
import AVFoundation
import Photos

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Profil görüntüsünü yüklemek için mevcut profil fotoğrafını ata
        profileImageView.image = profileImage
        
        // Profil fotoğrafının görüntüsünü daire şeklinde yap
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func selectProfilePhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImage = selectedImage
            profileImageView.image = selectedImage
            
            // Profil fotoğrafını Firebase Storage'a yükle
            uploadProfilePhoto(image: selectedImage) { [weak self] (url, error) in
                if let error = error {
                    // Hata durumunda işlemleri burada yönetebilirsiniz
                    print("Profil fotoğrafı yüklenirken hata oluştu: \(error.localizedDescription)")
                } else if let url = url {
                    // Yükleme başarılı olduğunda URL'yi sakla
                    // URL'yi kullanarak fotoğrafı daha sonra yüklemek için kullanabilirsiniz
                    print("Profil fotoğrafı başarıyla yüklendi. URL: \(url.absoluteString)")
                    // Burada URL'yi saklama veya kullanma işlemlerini gerçekleştirin
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // Profil fotoğrafını Firebase Storage'a yükleyen yöntem
    func uploadProfilePhoto(image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil, nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_photos").child("\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(url, nil)
            }
        }
    }
    
    // Profil fotoğrafını Firebase Storage'dan alarak ImageView'a yükleyen yöntem
    
    
    func loadProfilePhoto() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("profilePhotos").child(currentUser.uid)
        
        storageRef.downloadURL { [weak self] (url, error) in
            if let error = error {
                // Hata durumunda işlemleri burada yönetebilirsiniz
                print("Profil fotoğrafı yüklenirken hata oluştu: \(error.localizedDescription)")
            } else if let url = url {
                // URL'yi kullanarak profil fotoğrafını görüntüle
                self?.profileImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    // Profil fotoğrafını yüklemek için kullanıcıya izin isteyen yöntem
    func askForPhotoPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            showImagePicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.showImagePicker()
                    } else {
                        // Kullanıcı izin vermediğinde yapılacak işlemler
                    }
                }
            }
        case .denied:
            let alertController = UIAlertController(title: "Fotoğraf Erişimi Reddedildi", message: "Uygulama fotoğraf erişimi için izin gerektirir. Lütfen ayarlardan izin verin.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        case .restricted:
            let alertController = UIAlertController(title: "Fotoğraf Erişimi Kısıtlandı", message:  "Fotoğraf erişimi kısıtlandı. Lütfen ayarlardan izin verin.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    // Fotoğraf seçiciyi gösteren yöntem
    func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Profil fotoğrafını güncellemek için kullanıcıya izin isteyen yöntem
    func updateProfilePhoto() {
        let alertController = UIAlertController(title: "Profil Fotoğrafı", message: "Profil fotoğrafınızı güncellemek istiyor musunuz?", preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Fotoğraf Çek", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self?.askForCameraPermission()
            } else {
                // Cihazda kamera kullanılamıyor
            }
        }
        
        let choosePhotoAction = UIAlertAction(title: "Galeriden Seç", style: .default) { [weak self] _ in
            self?.askForPhotoPermission()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(choosePhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Kullanıcıya kamera izni isteyen yöntem
    func askForCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            showImagePicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.showImagePicker(sourceType: .camera)
                    } else {
                        // Kullanıcı izin vermediğinde yapılacak işlemler
                    }
                }
            }
        case .denied:
            let alertController = UIAlertController(title: "Kamera Erişimi Reddedildi", message: "Uygulama kamera erişimi için izin gerektirir. Lütfen ayarlardan izin verin.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        case .restricted:
            let alertController = UIAlertController(title: "Kamera Kullanımı Kısıtlandı", message: "Kamera kullanımı kısıtlandı. Lütfen ayarlardan izin verin.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            // Kullanıcı izin vermediğinde veya kısıtlamalı olduğunda yapılacak işlemler
        default:
            break
        }
    }
    
    // Fotoğraf seçiciyi gösteren yöntem
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
}
