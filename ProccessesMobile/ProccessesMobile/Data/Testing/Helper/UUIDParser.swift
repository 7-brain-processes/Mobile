//
//  UUIDParser.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

func parseUUID(_ value: String) throws -> UUID {
    guard let uuid = UUID(uuidString: value) else {
        throw APIError.invalidResponse
    }
    return uuid
}
