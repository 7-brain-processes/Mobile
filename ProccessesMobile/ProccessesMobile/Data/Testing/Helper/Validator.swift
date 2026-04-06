//
//  Validator.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

func validate(_ response: HTTPURLResponse, success: Int) throws {
    if response.statusCode == 401 { throw APIError.unauthorized }
    if response.statusCode == 403 { throw APIError.serverError(code: 403) }
    if response.statusCode == 404 { throw APIError.serverError(code: 404) }
    guard response.statusCode == success else {
        throw APIError.serverError(code: response.statusCode)
    }
}
