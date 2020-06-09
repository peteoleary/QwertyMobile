//
//  ItemViewRow.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/18/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import SwiftUI
import URLImage

struct ItemViewRow: View {
    var item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title).font(.title)
            if (item.qr_code != nil) {
                Text(item.qr_code!.url)
            }
            Text(item.description ?? "").font(.subheadline)
            URLImage(URL(string: item.image_url)!)
                .scaledToFit()
                .frame(width: 200.0,height:200)
        }
    }
}

let previewItem = Item(
    id: 1234,
    image_url: "",
    title: "This is the Title!",
    description: "I would try to describe this but it's too awesome"
)

struct ItemViewRow_Previews: PreviewProvider {
    
    static var previews: some View {
        QRCodeViewRow(qrcode: previewQR)
    }
}
