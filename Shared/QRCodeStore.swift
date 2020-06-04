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
    var credentials: Credentials?
    
    let suiteName = "group.com.UnitedTomatoCans.QwertyMobile"
    var userDefaults: UserDefaults
    
    init(credentials: Credentials?) {
        self.userDefaults = UserDefaults(suiteName: suiteName)!
        
        if (credentials == nil) {
            if let data = self.userDefaults.object(forKey: "credentials") as? Data {
                self.credentials = try? JSONDecoder().decode(Credentials.self, from: data)
            }
        }
        else {
            self.credentials = credentials
        }
    }
    
    func setCredentials (credentials: Credentials?) {
        
        // don't overwrite the token with any empty value, this happens when the token has not changed since the last call
        if credentials == nil || self.credentials == nil || !credentials!.token.isEmpty {
            self.credentials = credentials
            
            if let encoded = try? JSONEncoder().encode(credentials) {
                self.userDefaults.set(encoded, forKey: "credentials")
                self.userDefaults.synchronize()
            }
            
        }
    }
    
    func loggedIn() -> Bool {
        return credentials != nil
    }

    func fetch_qrcodes() throws {
        // recreate the QwertyAPI object each time as the viewRouter credentials may have changed
        let api = QwertyAPI(credentials: self.credentials)
        try api.getQRCodes() { (credentials: Credentials?, qrCodeData: [QRCode]?) in
            DispatchQueue.main.async {
                if qrCodeData != nil {
                    self.qrcodes = qrCodeData!
                    self.setCredentials(credentials: credentials)
                }
            }
        }
    }
    
    func fetch_items() throws {
        // recreate the QwertyAPI object each time as the viewRouter credentials may have changed
        let api = QwertyAPI(credentials: self.credentials)
        try api.getItems() { (credentials: Credentials?, itemData: [Item]?) in
            DispatchQueue.main.async {
                if itemData != nil {
                    self.items = itemData!
                    self.setCredentials(credentials: credentials)
                }
            }
        }
    }
}

