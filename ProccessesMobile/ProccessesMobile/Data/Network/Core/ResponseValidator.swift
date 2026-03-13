//
//  ResponseValidator.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum ResponseValidator {

    static func validate(
        _ response: HTTPURLResponse,
        successCodes: Set<Int>
    ) throws {

        if response.statusCode == 401 {
            throw APIError.unauthorized
        }

        guard successCodes.contains(response.statusCode) else {
            throw APIError.serverError(code: response.statusCode)
        }
    }
}
