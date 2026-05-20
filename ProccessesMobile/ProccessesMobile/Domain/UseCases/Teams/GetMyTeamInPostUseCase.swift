//
//  GetMyTeamInPostUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

protocol GetMyTeamInPostUseCase: Sendable {
    func execute(_ query: GetMyTeamInPostQuery) async throws -> StudentTeam
}
