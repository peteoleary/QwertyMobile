//
//  QRCodeView.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct QRCodeView : View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    @State var qrcode_store: QRCodeStore
    
    // TODO: load QR code list
    
    var body: some View {
        VStack {
            Text("Welcome!")
        }
    }
}

#if DEBUG
struct QRCodeView_Previews : PreviewProvider {
    static var previews: some View {
        QRCodeView(viewRouter: ViewRouter(), qrcode_store: QRCodeStore())
    }
}
#endif
