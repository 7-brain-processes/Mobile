//
//  Page.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import SwiftUI

struct PageDTO<T: Codable & Equatable & Sendable>: Equatable, Sendable, Codable {
    let content: [T]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}

extension PageDTO {
    func toDomain<U>(_ map: (T) throws -> U) rethrows -> Page<U> {
        Page(
            content: try content.map(map),
            page: page,
            size: size,
            totalElements: totalElements,
            totalPages: totalPages
        )
    }
}
