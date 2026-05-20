//
//  StudentDistributedGradeDTO.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import Foundation

struct StudentDistributedGradeDTO: Decodable, Equatable, Sendable {
    let student: UserDTO?
    let grade: Int?
}
