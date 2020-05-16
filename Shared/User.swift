//
//  User.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id:Int
    var first_name:String
    var last_name:String
    var email:String
    var nickname:String
    var image :String
}

struct Credentials {
    var uid: String
    var client_id: String
    var token: String
}
