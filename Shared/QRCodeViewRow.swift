//
//  QRCodeViewRow.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/18/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import SwiftUI

struct QRCodeViewRow: View {
    var qrcode: QRCode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(qrcode.title).font(.title)
            HStack {
                Text(qrcode.url).font(.subheadline)
                Spacer()
                Text(qrcode.description).font(.subheadline)
            }
        }
    }
}

let previewQR = QRCode(
    id: 1234,
    shortened_url: "http://t.co/zntfdr",
    url: "http://twitter.com/zntfdr",
    title: "This is the Title!",
    description: "I would try to describe this but it's too awesome",
    qr_code_svg: nil
)

struct QRCodeViewRow_Previews: PreviewProvider {
    
    static var previews: some View {
        QRCodeViewRow(qrcode: previewQR)
    }
}
