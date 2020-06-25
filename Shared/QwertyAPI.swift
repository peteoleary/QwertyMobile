//
//  QwertyAPI.swift
//  QwertyMobile
//
//  Created by Peter O'Leary on 5/16/20.
//  Copyright © 2020 United Tomato Cans, Inc. All rights reserved.
//

import Foundation

enum QwertyAPIError: Error {
    case unknownError
    case credentialsRequired
    case unauthorizedRequest
}


class QwertyAPICall {
    
    var restManager: RestManager
    var credentials: Credentials?
    
    init(credentials: Credentials? = nil) {
        self.restManager = RestManager()
        self.credentials = credentials
    }
    
    private func getUrl(path: String) -> URL?{
        // let server_url = "https://b471e9480d0e.ngrok.io"
        let server_url = "https://qrtee.herokuapp.com"
        return URL(string: "\(server_url)\(path)")
    }
    
    private func addAnonymousHeaders() {
        self.restManager.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
    }
    
    private func addAuthenticatedHeaders() throws {
        
        if self.credentials == nil {
            throw QwertyAPIError.credentialsRequired
        }
        self.addAnonymousHeaders()
        
        self.restManager.requestHttpHeaders.add(value: self.credentials!.uid, forKey: "uid")
        self.restManager.requestHttpHeaders.add(value: self.credentials!.client_id, forKey: "client")
        self.restManager.requestHttpHeaders.add(value: self.credentials!.token, forKey: "access-token")
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
                    let creds = Credentials(uid: response.headers[caseInsensitive: "uid"]!, client_id: response.headers[caseInsensitive: "client"]!, token: response.headers[caseInsensitive: "access-token"]!)
                    
                    completion(creds, userData)
                    
                // TODO: if there is a decoding error, the new credentials are not sent back to the caller and therefore we will lose them
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

            } else {
                completion(nil, nil)
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
    
    public func getQRCodes(completion: @escaping (_ credentals: Credentials?, _ qrCodeData: [QRCode]? ) -> Void) throws {
        guard let url = getUrl(path: "/api/qr_codes") else { completion(nil, nil); return }
        try self.addAuthenticatedHeaders()
        self.handleResults(url: url, httpMethod: RestManager.HttpMethod.get, completion: completion)
    }
    
    public func getItems(completion: @escaping (_ credentals: Credentials?, _ itemData: [Item]? ) -> Void) throws {
        guard let url = getUrl(path: "/api/items") else { completion(nil, nil); return }
        try self.addAuthenticatedHeaders()
        self.handleResults(url: url, httpMethod: RestManager.HttpMethod.get, completion: completion)
    }
    
    private func addAll(keysAndValues: Any) {
        for child in Mirror(reflecting: keysAndValues).children {
            let stringValue = "\(child.value)"
            self.restManager.httpBodyParameters.add(value: stringValue, forKey: child.label!)
        }
    }
    
    public func updateItem(item: Item, completion: @escaping (_ credentals: Credentials?, _ itemData: Item? ) -> Void) throws {
        guard let url = getUrl(path: "/api/items/\(item.id)") else { completion(nil, nil); return }
        try self.addAuthenticatedHeaders()
        self.addAll(keysAndValues: item)
        self.handleResults(url: url, httpMethod: RestManager.HttpMethod.put, completion: completion)
    }
    
    public func updateQrcode(qrcode: QRCode, completion: @escaping (_ credentals: Credentials?, _ qrCodeData: QRCode? ) -> Void) throws {
        guard let url = getUrl(path: "/api/qr_codes/\(qrcode.id)") else { completion(nil, nil); return }
        try self.addAuthenticatedHeaders()
        self.addAll(keysAndValues: qrcode)
        self.handleResults(url: url, httpMethod: RestManager.HttpMethod.put, completion: completion)
    }
}
