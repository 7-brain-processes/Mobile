//
//  RemoveMemberCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct RemoveMemberCommand: Equatable, Sendable {
    let courseId: UUID
    let userId: UUID
}
