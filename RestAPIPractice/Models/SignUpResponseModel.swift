//
//  LoginRespomseModel.swift
//  RestAPIPractice
//
//  Created by iOS Training on 12/12/18.
//  Copyright © 2018 iOS Training. All rights reserved.
//

import UIKit

struct SignUpResponseModel: Decodable {
    var kind: String = ""
    var localId: String = ""
    var email: String = ""
    var displayName: String = ""
    var idToken: String = ""
    var registered: Bool = false
    var refreshToken: String = ""
    var expiresIn: String = ""
}
struct SignUpRequestModel: Encodable {
    var email: String
    var password: String
    var returnSecureToken: Bool
}
struct Detailsd {
    var name: String
    var age: Int
    var rollNumber: Int
    
}

    
    
    
    
    

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


