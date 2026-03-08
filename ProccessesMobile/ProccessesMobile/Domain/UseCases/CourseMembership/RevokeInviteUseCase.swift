//
//  RevokeInviteUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol RevokeInviteUseCase: Sendable {
    func execute(_ command: RevokeInviteCommand) async throws
}
