//
//  APIClient.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

final class APIClient: Sendable {
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

        #if DEBUG
        logRequest(request)
        #endif

        let (data, response) = try await httpClient.send(request)

        #if DEBUG
        logResponse(response, data: data)
        #endif

        return (data, response)
    }
}

#if DEBUG
private extension APIClient {

    func logRequest(_ request: URLRequest) {
        print("\n🚀 HTTP REQUEST")

        if let method = request.httpMethod,
           let url = request.url {
            print("\(method) \(url.absoluteString)")
        }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            headers.forEach { key, value in
                print("  \(key): \(value)")
            }
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8),
           !bodyString.isEmpty {
            print("Body:")
            print(bodyString)
        }

        print("---------")
    }

    func logResponse(_ response: HTTPURLResponse, data: Data) {
        print("📥 HTTP RESPONSE")

        if let url = response.url {
            print("URL: \(url.absoluteString)")
        }

        print("Status: \(response.statusCode)")

        if !response.allHeaderFields.isEmpty {
            print("Headers:")
            response.allHeaderFields.forEach {
                print("  \($0.key): \($0.value)")
            }
        }

        if let body = String(data: data, encoding: .utf8), !body.isEmpty {
            print("Body:")
            print(body)
        } else if !data.isEmpty {
            print("Body: <\(data.count) bytes binary>")
        }

        print("=========\n")
    }
}
#endif
