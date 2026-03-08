//
//  AuthorizedHTTPClient.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class AuthorizedHTTPClient: HTTPClient {
    private let decoratee: HTTPClient
    private let tokenStorage: TokenStorage
    
    init(decoratee: HTTPClient, tokenStorage: TokenStorage) {
        self.decoratee = decoratee
        self.tokenStorage = tokenStorage
    }
    
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        var signedRequest = request
        
        if let token = try? tokenStorage.getToken() {
            signedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await decoratee.send(signedRequest)
        
        if response.statusCode == 401 {
            //TODO: Here the logic of refresh should be implemented
            throw APIError.unauthorized
        }
        
        return (data, response)
    }
}
