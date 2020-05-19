//
//  QRCodeStore.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/18/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation
import Combine

class QRCodeStore: ObservableObject {
    @Published private(set) var qrcodes: [QRCode] = []
    
    var api:QwertyAPI
    init(credentials: Credentials?) {
        self.api = QwertyAPI(credentials: credentials)
    }

    func fetch() throws {
        try api.getQRCodes() { (credentials: Credentials?, qrCodeData: QRCodeData?) in
            DispatchQueue.main.async {
                if qrCodeData != nil {
                    self.qrcodes = qrCodeData!.data
                }
            }
        }
    }
}

