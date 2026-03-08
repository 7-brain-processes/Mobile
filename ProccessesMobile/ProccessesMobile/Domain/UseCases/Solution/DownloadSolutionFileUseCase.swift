//
//  DownloadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol DownloadSolutionFileUseCase: Sendable {
    func execute(_ query: DownloadSolutionFileQuery) async throws -> Data
}

// TODO: 
struct DownloadSolutionFileQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
    let fileId: UUID
}
