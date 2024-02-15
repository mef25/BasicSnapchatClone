//
//  ViewControllerSettings.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 14.02.2024.
//

import UIKit
import Firebase
class ViewControllerSettings: UIViewController {
let alarm = ViewControllerSign()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try 
            Auth.auth().signOut()
            self.performSegue(withIdentifier: "giris", sender: nil)
        }catch{
            self.alarm.alert(mesaj: "Error")
        }
    }
    
  

}
