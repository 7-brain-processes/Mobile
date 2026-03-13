//
//  RequestBuilder.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

struct RequestBuilder {

    private let encoder: JSONEncoder

    init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
    }

    func build(
        endpoint: Endpoint,
        baseURL: URL,
        token: String?
    ) throws -> URLRequest {

        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if endpoint.requiresAuth, let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        switch endpoint.body {

        case .none:
            break

        case .json(let encodable):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try encoder.encode(AnyEncodable(encodable))

        case .raw(let data, let contentType):
            if let contentType {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            request.httpBody = data
        }

        return request
    }
}

private struct AnyEncodable: Encodable {

    private let encodeFunc: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self.encodeFunc = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
