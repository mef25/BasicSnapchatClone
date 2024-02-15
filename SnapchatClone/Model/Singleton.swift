//
//  Singleton.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 14.02.2024.
//

import Foundation

class UserSingleton{
    
    static let sharedUserinfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() {
       
    }
}
