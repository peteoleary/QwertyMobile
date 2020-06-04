//
//  User.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation

struct UserData: Codable {
    var data: User
}

// "{\"data\":{\"id\":18,\"email\":\"pete@timelight.com\",\"provider\":\"email\",\"uid\":\"pete@timelight.com\",\"allow_password_change\":false,\"first_name\":\"Peter\",\"last_name\":\"O\'Leary\",\"nickname\":null,\"image\":null}}"

struct User: Codable {
    var id:Int
    var first_name:String
    var last_name:String
    var email:String
    var nickname:String?
    var image :String?
    var provider :String
    var uid:String
    var allow_password_change:Bool
}

struct Credentials: Codable {
    var uid: String
    var client_id: String
    var token: String
}
