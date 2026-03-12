//
//  LoginCommand.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct LoginCommand: Equatable, Sendable {
    let username: String
    let password: String
}
