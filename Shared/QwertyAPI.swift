//
//  QwertyAPI.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation

enum QwertyAPIError: Error {
    case credentialsRequired
}


class QwertyAPI {
    
    var restManager: RestManager
    var credentials: Credentials?
    
    init(credentials: Credentials? = nil) {
        self.restManager = RestManager()
        self.credentials = credentials
    }
    
    private func getUrl(path: String) -> URL?{
        return URL(string: "http://localhost:3001\(path)")
    }
    
    private func addAnonymousHeaders() {
        self.restManager.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
    }
    
    private func addAuthenticatedHeaders() throws {
        
        if self.credentials == nil {
            throw QwertyAPIError.credentialsRequired
        }
        
        self.addAnonymousHeaders()
    }
    
    private func handleResults<T:Codable>(url: URL, httpMethod: RestManager.HttpMethod, completion: @escaping (_ credentals: Credentials?, _ result: T?) -> Void) {
        self.restManager.makeRequest(toURL: url, withHttpMethod: httpMethod) { (results) in
            guard let response = results.response else { completion(nil, nil); return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { completion(nil, nil); return }
                let decoder = JSONDecoder()
                // guard let userData = try? decoder.decode(UserData.self, from: data) else { return }
                
                do {
                   let userData = try decoder.decode(T.self, from: data)
                    let creds = Credentials(uid: response.headers["uid"]!, client_id: response.headers["client"]!, token: response.headers["access-token"]!)
                    
                    completion(creds, userData)
                    
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }

            }
        }
    }
    
    public func login(email: String, password: String, completion: @escaping (_ credentals: Credentials?, _ loggedInUser: UserData? ) -> Void){
        guard let url = getUrl(path: "/api/auth/sign_in") else { completion(nil, nil); return }

        self.addAnonymousHeaders()
        
        // {email:email, password:password}
        self.restManager.httpBodyParameters.add(value: email, forKey: "email")
        self.restManager.httpBodyParameters.add(value: password, forKey: "password")
        
        self.handleResults(url: url, httpMethod: RestManager.HttpMethod.post, completion: completion)
    }
    
    public func getQRCodes(completion: @escaping (_ credentals: Credentials?, _ qrCodeData: QRCodeData? ) -> Void) throws {
        guard let url = getUrl(path: "/api/qr_codes") else { completion(nil, nil); return }
        try self.addAuthenticatedHeaders()
        self.handleResults(url: url, httpMethod: RestManager.HttpMethod.get, completion: completion)
    }
}
