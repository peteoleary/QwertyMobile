//
//  QRCode.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation

struct QRCode: Decodable {
    var id:Int
    var shortened_url:String
    var url:String
    var title:String
    var description:String
    var qr_code_svg:String
}
