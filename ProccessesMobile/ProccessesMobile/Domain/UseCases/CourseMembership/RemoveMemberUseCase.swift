//
//  RemoveMemberUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol RemoveMemberUseCase: Sendable {
    func execute(_ command: RemoveMemberCommand) async throws
}
