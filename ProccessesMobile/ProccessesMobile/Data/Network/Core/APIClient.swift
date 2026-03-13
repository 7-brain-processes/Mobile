//
//  APIClient.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

final class APIClient : Sendable {
    private let httpClient: HTTPClient
    private let requestBuilder: RequestBuilder
    private let tokenProvider: AccessTokenProvider?
    private let configuration: APIConfiguration

    init(
        httpClient: HTTPClient,
        configuration: APIConfiguration,
        requestBuilder: RequestBuilder = RequestBuilder(),
        tokenProvider: AccessTokenProvider? = nil
    ) {
        self.httpClient = httpClient
        self.configuration = configuration
        self.requestBuilder = requestBuilder
        self.tokenProvider = tokenProvider
    }

    func send(_ endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        let token = try tokenProvider?.accessToken()

        let request = try requestBuilder.build(
            endpoint: endpoint,
            baseURL: configuration.baseURL,
            token: token
        )

        return try await httpClient.send(request)
    }
}
