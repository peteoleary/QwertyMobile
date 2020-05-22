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
    var viewRouter: ViewRouter
    
    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
    }

    func fetch() throws {
        // recreate the QwertyAPI object each time as the viewRouter credentials may have changed
        let api = QwertyAPI(credentials: viewRouter.credentials)
        try api.getQRCodes() { (credentials: Credentials?, qrCodeData: [QRCode]?) in
            DispatchQueue.main.async {
                if qrCodeData != nil {
                    self.qrcodes = qrCodeData!
                    self.viewRouter.setCredentials(credentials: credentials)
                }
            }
        }
    }
}

