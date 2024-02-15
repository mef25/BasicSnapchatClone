//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 14.02.2024.
//

import UIKit
import Firebase

class ViewControllerSign: UIViewController {
    @IBOutlet var mail: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signin: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @IBAction func signIn(_ sender: Any) {
        if mail.text != "" && password.text != ""{
            Auth.auth().signIn(withEmail:mail.text!, password: password.text!) { data, error in
                if error != nil{
                    self.alert(mesaj: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "tabbar", sender: nil)
                }
            }
        }else{
            self.alert(mesaj: "Mail/Password is invalid")
        }
       
    }
    
    
    func alert(mesaj:String){
        let alarm = UIAlertController(title: "Error", message: mesaj, preferredStyle: .alert)
        let buton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alarm.addAction(buton)
        self.present(alarm, animated: true)
    }
    
}

