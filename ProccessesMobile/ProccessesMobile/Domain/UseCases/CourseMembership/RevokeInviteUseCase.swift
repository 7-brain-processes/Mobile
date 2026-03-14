//
//  RevokeInviteUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


import Foundation

protocol RevokeInviteUseCase: Sendable {
    func execute(_ command: RevokeInviteCommand) async throws
}