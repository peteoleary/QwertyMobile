//
//  QRCodeView.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct ItemView : View {
    
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var qrcodeStore: QRCodeStore
    
    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
    }

        
    var body: some View {
        NavigationView {
            List {
                Button("Refresh...", action: fetch)
                ForEach(self.qrcodeStore.items, id: \.self) { item in
                    ItemViewRow(item: item).onTapGesture {
                        /* actions here */ }
                }
            }.navigationBarTitle(Text("Items"))
        }.onAppear(perform: fetch)
    }

    private func fetch() {
        do {
            try qrcodeStore.fetch_items()
        } catch {
            viewRouter.alertTitle = "Error"
            viewRouter.alertMessage = "Could not load the Items list \(error)"
            viewRouter.showAlert = true
        }
    }}

#if DEBUG
struct ItemView_Previews : PreviewProvider {
    static var previews: some View {
        let vr = ViewRouter()
        return QRCodeView(viewRouter: vr)
    }
}
#endif
