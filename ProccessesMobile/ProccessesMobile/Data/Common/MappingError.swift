//
//  MappingError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

enum MappingError: Error, Equatable {
    case invalidUUID(field: String, value: String)
    case invalidDate(field: String, value: String)
}
