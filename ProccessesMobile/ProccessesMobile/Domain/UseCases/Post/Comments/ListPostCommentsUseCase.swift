//
//  ListPostCommentsUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

protocol ListPostCommentsUseCase: Sendable {
    func execute(_ query: ListPostCommentsQuery) async throws -> Page<Comment>
}