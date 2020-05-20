//
//  MotherView.swift
//  NavigateInSwiftUIComplete
//
//  Created by Andreas Schultz on 19.07.19.
//  Copyright © 2019 Andreas Schultz. All rights reserved.
//

import SwiftUI
import Combine

struct MainView : View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
            VStack {
                // TODO: check if credentials are valid
                
                if viewRouter.currentPage == "login" {
                    LoginView(viewRouter: viewRouter)
                } else if viewRouter.currentPage == "qrcode" {
                    QRCodeView(viewRouter: viewRouter, qrcode_store: QRCodeStore(viewRouter: viewRouter))
                }
            }.alert(isPresented: $viewRouter.showAlert) {
                Alert(title: Text(viewRouter.alertTitle!), message: Text(viewRouter.alertMessage!), dismissButton: .default(Text("Got it!")))
        }

    }
}

#if DEBUG
struct MotherView_Previews : PreviewProvider {
    static var previews: some View {
        MainView(viewRouter: ViewRouter())
    }
}
#endif
