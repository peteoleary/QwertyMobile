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
    @Published private(set) var items: [Item] = []
    var viewRouter: ViewRouter
    
    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
    }

    func fetch_qrcodes() throws {
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
    
    func fetch_items() throws {
        // recreate the QwertyAPI object each time as the viewRouter credentials may have changed
        let api = QwertyAPI(credentials: viewRouter.credentials)
        try api.getItems() { (credentials: Credentials?, itemData: [Item]?) in
            DispatchQueue.main.async {
                if itemData != nil {
                    self.items = itemData!
                    self.viewRouter.setCredentials(credentials: credentials)
                }
            }
        }
    }
}

