//
//  KeyboardResponsive.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 6/5/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public class KeyboardInfo: ObservableObject {

    public static var shared = KeyboardInfo()

    @Published public var height: CGFloat = 0

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardChanged(notification: Notification) {
        if notification.name == UIApplication.keyboardWillHideNotification {
            self.height = 0
        } else {
            self.height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
        }
    }

}

struct KeyboardAware: ViewModifier {
    @ObservedObject private var keyboard = KeyboardInfo.shared

    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.keyboard.height)
            .edgesIgnoringSafeArea(self.keyboard.height > 0 ? .bottom : [])
            .animation(.easeOut)
    }
}

extension View {
    public func keyboardAware() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAware())
    }
}
