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
    
    @State private var showModal = false
    @State private var editableItem: Item = emptyItem
    @State private var newUrlString: String = ""
    
    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
    }
    
    func doUpdateCurrentItem() {
        qrcodeStore.updateItem(item: <#T##Item#>)
    }

    var body: some View {
        NavigationView {
            List {
                Button("Refresh...", action: fetch)
                if (self.viewRouter.shareURL != nil) {
                    Text(self.viewRouter.shareURL!.absoluteString)
                }
                ForEach(self.qrcodeStore.items, id: \.self) { item in
                    ItemViewRow(item: item).onTapGesture {
                        self.newUrlString = (self.viewRouter.shareURL != nil ? self.viewRouter.shareURL!.absoluteString : item.qr_code!.url)
                        self.editableItem = item
                        self.showModal = true
                    }.betterSheet(isPresented: self.$showModal, onDismiss: {
                        if (self.newUrlString.count > 0) {
                            self.doUpdateCurrentItem()
                        }
                    }) {
                        EditItemModal(showModal: self.$showModal, editableItem: self.$editableItem, newUrlString: self.$newUrlString)
                    }
                }
            }.navigationBarTitle(Text("Items"))
        }.onAppear(perform: fetch)
    }

    private func fetch() {
        do {
            try qrcodeStore.fetchItems()
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
