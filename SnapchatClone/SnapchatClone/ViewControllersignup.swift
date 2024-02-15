//
//  ViewControllersignup.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 15.02.2024.
//

import UIKit
import Firebase
class ViewControllersignup: UIViewController {
    @IBOutlet var mail: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var password2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signup(_ sender: Any) {
        if mail.text != "" && password.text != "" && username.text != "" && password2.text == password.text{
            Auth.auth().createUser(withEmail: mail.text!, password: password.text!) { data, error in
                if error != nil{
                    self.alert(mesaj: error?.localizedDescription ?? "error")
                }else{
                    let firestore = Firestore.firestore()
                    let kayit = ["username" : self.username.text!, "email" : self.mail.text!] as [String : Any]
                    firestore.collection("kullanıcıAdları").addDocument(data: kayit) { error in
                        //
                    }
                    self.performSegue(withIdentifier: "tabbar", sender: nil)
                }
            }
        }else if password.text != password2.text{
            self.alert(mesaj: "Password does not match")
        }else{
            self.alert(mesaj: "Mail/Username/Password is invalid")
        }
    }
    
    func alert(mesaj:String){
        let alarm = UIAlertController(title: "Error", message: mesaj, preferredStyle: .alert)
        let buton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alarm.addAction(buton)
        self.present(alarm, animated: true)
    }
    

}
