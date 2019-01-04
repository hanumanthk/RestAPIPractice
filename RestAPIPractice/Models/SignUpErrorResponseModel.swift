//
//  SignUpErrorResponseModel.swift
//  RestAPIPractice
//
//  Created by iOS Training on 12/12/18.
//  Copyright © 2018 iOS Training. All rights reserved.
//

import UIKit

struct SignUpErrorResponseModel: Decodable {
    var error: SignUpOuterError = SignUpOuterError()
}


struct SignUpOuterError: Decodable {
    var code: Int = 0
    var message: String = ""
    var errors: [SignUpError] = [SignUpError]()
}


struct SignUpError: Decodable {
    var message: String = ""
    var domain: String = ""
    var reason: String = ""
}

