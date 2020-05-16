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
    
    var currentPage: String = "login" {
        didSet {
            objectWillChange.send(self)
        }
    }
    var credentials: Credentials? {
        didSet {
            objectWillChange.send(self)
        }
    }
}
