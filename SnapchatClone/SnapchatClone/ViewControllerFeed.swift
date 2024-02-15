//
//  ViewControllerFeed.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 14.02.2024.
//

import UIKit
import Firebase
import Kingfisher
class ViewControllerFeed: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    
    let alarm = ViewControllerSign()
    let firestoreDatabase = Firestore.firestore()
    
    var snapArray = [UserSnap]()
    var secilensnap : UserSnap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        getData()
        getsnaps()
    }
    
    func getData(){
        firestoreDatabase.collection("kullanıcıAdları").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in // get documents güncelleme yapmaz
            if error != nil{
                self.alarm.alert(mesaj: error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false{
                    for document in snapshot!.documents{
                        if let username = document.get("username"){
                            UserSingleton.sharedUserinfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserinfo.username = username as! String
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getsnaps(){
        firestoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in // snapshot her değişiklik olduğunda güncelleme yapar
            if error != nil{
                self.alarm.alert(mesaj: error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false{
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        
                        let id = document.documentID
                        
                        if let username = document.get("snapowner") as? String{
                            if let imageurl = document.get("imageurlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp{
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if difference >= 24{
                                            self.firestoreDatabase.collection("Snaps").document(id).delete{ (error) in
                                                
                                            }
                                             
                                        }else{
                                            let snap = UserSnap(usernamesnap: username, imageurlsnap: imageurl, date: date.dateValue(), timeDifference : 24 - difference)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.table.reloadData()
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cellfeed", for: indexPath) as! TableViewCellfeed
        cell.usernamefeed.text = snapArray[indexPath.row].usernamesnap
        cell.imagefeed.kf.setImage(with: URL(string: snapArray[indexPath.row].imageurlsnap[0]))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilensnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "snap", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "snap"{
            let hedef = segue.destination as! ViewControllerSnap
            hedef.secilensnap = secilensnap
        }
    }

}
