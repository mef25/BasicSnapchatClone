//
//  ViewControllerUpload.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 14.02.2024.
//

import UIKit
import Firebase
import FirebaseStorage
class ViewControllerUpload: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var image: UIImageView!
    @IBOutlet var uploadbuton: UIButton!
    let alarm = ViewControllerSign()
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadbuton.isEnabled = false
        image.isUserInteractionEnabled = true
        let tiklama = UITapGestureRecognizer(target: self, action: #selector(galeriac))
        image.addGestureRecognizer(tiklama)
        
    }
    @objc func galeriac(){
        let picker = UIImagePickerController()
        picker.delegate=self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        uploadbuton.isEnabled = true
        self.dismiss(animated: true)
    }
    
    
    @IBAction func upload(_ sender: Any) {
        // Storage
        let storage = Storage.storage()
        let storageref = storage.reference()
        let folder = storageref.child("resimler")
        
        if let data = image.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let folder2 = folder.child(uuid)
            folder2.putData(data, metadata: nil) { metadata, error in
                if error != nil{
                    self.alarm.alert(mesaj: error?.localizedDescription ?? "error")
                }else{
                    folder2.downloadURL { url, error in
                        if error != nil{
                            self.alarm.alert(mesaj: error?.localizedDescription ?? "error")
                        }else{
                            let imageurl = url?.absoluteString
                            // Firestore
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Snaps").whereField("snapowner", isEqualTo: UserSingleton.sharedUserinfo.username).getDocuments { snapshot, error in
                                if error != nil{
                                    self.alarm.alert(mesaj: error?.localizedDescription ?? "error")
                                }else{
                                    if snapshot?.isEmpty == false{
                                        for document in snapshot!.documents{
                                            let documentID = document.documentID
                                            if var imagearray = document.get("imageurlArray") as? [String]{
                                                imagearray.append(imageurl!)
                                                let yenidata = ["imageurlArray" : imagearray] as [String : Any]
                                                firestore.collection("Snaps").document(documentID).setData(yenidata, merge: true) { error in
                                                    if error != nil{
                                                        self.alarm.alert(mesaj: error?.localizedDescription ?? "error")
                                                    }else{
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.image.image = UIImage(named: "90")
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        let snap = ["imageurlArray" : [imageurl!], "snapowner" : UserSingleton.sharedUserinfo.username, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                        firestore.collection("Snaps").addDocument(data: snap) { error in
                                            if error != nil{
                                                self.alarm.alert(mesaj: error?.localizedDescription ?? "error")
                                            }
                                            else{
                                                self.tabBarController?.selectedIndex = 0
                                                self.image.image = UIImage(named: "90")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
