//
//  MainView.swift
//  NavigateInSwiftUIComplete
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import SwiftUI
import Combine

struct MainView : View {
    
    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var qrcodeStore: QRCodeStore
    
    var body: some View {
            VStack {
                if !qrcodeStore.loggedIn() {
                     LoginView(viewRouter: viewRouter)
                } else if viewRouter.currentPage == "qrcode" {
                    QRCodeView(viewRouter: viewRouter)
                } else if viewRouter.currentPage == "items" {
                    ItemView(viewRouter: viewRouter)
                }
            }.alert(isPresented: $viewRouter.showAlert) {
                Alert(title: Text(viewRouter.alertTitle!), message: Text(viewRouter.alertMessage!), dismissButton: .default(Text("Got it!")))
        }

    }
}

#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        MainView(viewRouter: ViewRouter())
    }
}
#endif
