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
    @EnvironmentObject var qrcodeStore: QRCodeStore
    
    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
    }

        
    var body: some View {
        NavigationView {
            List {
                Button("Refresh...", action: fetch)
                ForEach(self.qrcodeStore.qrcodes, id: \.self) { qr in
                    QRCodeViewRow(qrcode: qr)
                }
            }.navigationBarTitle(Text("QR Codes"))
        }.onAppear(perform: fetch)
    }

    private func fetch() {
        do {
            try qrcodeStore.fetchQrcodes()
        } catch {
            viewRouter.alertTitle = "Error"
            viewRouter.alertMessage = "Could not load the QR Code list \(error)"
            viewRouter.showAlert = true
        }
    }}

#if DEBUG
struct QRCodeView_Previews : PreviewProvider {
    static var previews: some View {
        let vr = ViewRouter()
        return QRCodeView(viewRouter: vr)
    }
}
#endif
