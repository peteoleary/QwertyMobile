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
    
    var alertMessage:String?
    var alertTitle: String?
    
    var showAlert: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var shareURL: URL? = nil {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var currentPage: String = "items" {
        didSet {
            objectWillChange.send(self)
        }
    }
    
}
