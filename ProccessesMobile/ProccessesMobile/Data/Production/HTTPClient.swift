//
//  HTTPClient.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public protocol HTTPClient: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
