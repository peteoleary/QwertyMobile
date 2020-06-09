//
//  EditItemModal.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 6/7/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct EditItemModal: View {
    // 1.
    @Binding var showModal: Bool
    
    @Binding var editableItem: Item
    @Binding var newUrlString: String
    
    func isStringLink(string: String) -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && string.count > 0) else { return false }
        if detector!.numberOfMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count)) > 0 {
            return true
        }
        return false
    }

            
    var body: some View {
        VStack {
            TextField("", text: $newUrlString)
                .padding()
            Button("Save") {
                self.showModal.toggle()
                }.disabled(editableItem.qr_code!.url == newUrlString || !isStringLink(string: newUrlString)).padding()
            Button("Dismiss") {
                self.newUrlString = ""
                self.showModal.toggle()
            }.padding()
        }
    }
}

struct EditItemModal_Previews: PreviewProvider {
    static var previews: some View {
        EditItemModal(showModal: .constant(true), editableItem: .constant(emptyItem), newUrlString: .constant("New text"))
    }
}
