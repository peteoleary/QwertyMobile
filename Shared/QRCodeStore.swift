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

    func fetchQrcodes() throws {
        // recreate the QwertyAPI object each time as the viewRouter credentials may have changed
        try QwertyAPICall(credentials: self.credentials).getQRCodes() { (credentials: Credentials?, qrCodeData: [QRCode]?) in
            DispatchQueue.main.async {
                self.setCredentials(credentials: credentials)
                if qrCodeData != nil {
                    self.qrcodes = qrCodeData!
                }
            }
        }
    }
    
    func updateItem(replacement_item: Item) {
        
        do {
            self.items = try self.items.map({current_item in
                if (replacement_item.id == current_item.id) {
                    // TODO: make REST call to update item if appropriate
                    
                    // FOR NOW: make REST call to update qrode if appropriate
                    try QwertyAPICall(credentials: self.credentials).updateQrcode(qrcode: replacement_item.qr_code!) { (credentials: Credentials?, qrcodeData: QRCode?) in
                        DispatchQueue.main.async {
                            self.setCredentials(credentials: credentials)
                        }
                    }
                    
                    return replacement_item
                }
                return current_item
            })
        } catch {
            // TODO: error message here
        }
    }
    
    func fetchItems() throws {
        // recreate the QwertyAPI object each time as the viewRouter credentials may have changed
        try QwertyAPICall(credentials: self.credentials).getItems() { (credentials: Credentials?, itemData: [Item]?) in
            DispatchQueue.main.async {
                self.setCredentials(credentials: credentials)
                if itemData != nil {
                    self.items = itemData!
                }
            }
        }
    }
}

