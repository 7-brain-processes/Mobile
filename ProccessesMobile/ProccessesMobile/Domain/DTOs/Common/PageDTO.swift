//
//  Page.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct PageDTO<T: Codable & Equatable & Sendable>: Equatable, Sendable, Codable {
    let content: [T]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}
