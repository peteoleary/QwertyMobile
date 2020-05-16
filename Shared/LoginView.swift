//
//  LoginView.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/15/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let storedUsername = "Pete_oleary"
let storedPassword = "astroman"

struct LoginView : View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var authenticationDidFail: Bool = false
    
    var body: some View {
        VStack {
            WelcomeText()
            UserImage()
            UserNameTextField(username: $username)
            PasswordSecureField(password: $password)
            if authenticationDidFail {
                Text("Information not correct. Try again.")
                    .offset(y: -10)
                    .foregroundColor(.red)
            }
                        
            Button(action: {
                
                let qwerty = QwertyAPI()
                
                let credentials: Credentials? = qwerty.login(username: self.username, password: self.password)
                
                if credentials != nil {
                        self.viewRouter.credentials = credentials
                        }
                else {
                        self.authenticationDidFail = true
                    }
                }
            ) {
                LoginButtonContent()
            }
            
            
        }.padding()
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewRouter: ViewRouter())
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UserImage: View {
    var body: some View {
        Image("Pepper Instagram").resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}

struct LoginButtonContent: View {
    var body: some View {
        Text("Login")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct UserNameTextField: View {
    @Binding var username: String
    var body: some View {
        TextField("Username", text: $username).padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
