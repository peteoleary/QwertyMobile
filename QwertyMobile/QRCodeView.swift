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
        
    var body: some View {
        NavigationView {
            List {
                Button("Refresh...", action: fetch)
                ForEach(qrcode_store.qrcodes, id: \.self) { qr in
                    QRCodeViewRow(qrcode: qr)
                }
            }.navigationBarTitle(Text("QR Codes"))
        }.onAppear(perform: fetch)
    }

    private func fetch() {
        do {
            try qrcode_store.fetch()
        } catch {
            viewRouter.alertTitle = "Error"
            viewRouter.alertMessage = "Could not load the QR Code list \(error)"
            viewRouter.showAlert = true
        }
    }}

#if DEBUG
struct QRCodeView_Previews : PreviewProvider {
    static var previews: some View {
        QRCodeView(viewRouter: ViewRouter(), qrcode_store: QRCodeStore(credentials: nil))
    }
}
#endif
