//
//  QRCode.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation

struct QRCode: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id:Int
    var shortened_url:String
    var url:String
    var title:String
    var description:String
    var qr_code_svg:String?
}

struct QRCodeData: Codable, Hashable {
    var data: [
        QRCode
    ]
}
