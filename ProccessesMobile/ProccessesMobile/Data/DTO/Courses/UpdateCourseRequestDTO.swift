//
//  UpdateCourseRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Foundation

struct UpdateCourseRequestDTO: Equatable, Sendable, Codable {
    let name: String?
    let description: String?
}
