//
//  ListSolutionFilesUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol ListSolutionFilesUseCase: Sendable {
    func execute(_ query: ListSolutionFilesQuery) async throws -> [AttachedFile]
}
