//
//  URLSessionHTTPClient.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            return (data, httpResponse)
        } catch {
            throw APIError.underlying(error)
        }
    }
}
