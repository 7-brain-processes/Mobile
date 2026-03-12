//
//  RegisterCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct RegisterCommand: Equatable, Sendable {
    let username: String
    let password: String
    let displayName: String?
}
