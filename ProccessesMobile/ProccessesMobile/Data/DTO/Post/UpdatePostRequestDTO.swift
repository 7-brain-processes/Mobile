//
//  UpdatePostRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct UpdatePostRequestDTO: Equatable, Sendable, Codable {
    let title: String?
    let content: String?
    let deadline: String?
}
