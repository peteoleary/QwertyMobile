//
//  QwertyAPI.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation

class QwertyAPI {
    var restManager = RestManager()
    
    public func login(username: String, password: String) -> Credentials? {
        guard let url = URL(string: "https://reqres.in/api/users") else { return nil }

        restManager.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restManager.httpBodyParameters.add(value: "John", forKey: "name")
        restManager.httpBodyParameters.add(value: "Developer", forKey: "job")

        restManager.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 201 {
                guard let data = results.data else { return }
                let decoder = JSONDecoder()
                guard let loggedInUser = try? decoder.decode(User.self, from: data) else { return }
                
                return Credentials(uid: response.headers["uid"], client_id: response.headers["uid"], token: response.headers["uid"])
            }
        }
    }
}
