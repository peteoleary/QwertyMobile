//
//  ViewRouter.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var credentials: Credentials?
    
    func setCredentials (credentials: Credentials?) {
        
        // don't overwrite the token with any empty value, this happens when the token has not changed since the last call
        if credentials == nil || self.credentials == nil || !credentials!.token.isEmpty {
            self.credentials = credentials
        }
    }
    
    var alertMessage:String?
    var alertTitle: String?
    var showAlert: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var currentPage: String = "login" {
        didSet {
            objectWillChange.send(self)
        }
    }
}
