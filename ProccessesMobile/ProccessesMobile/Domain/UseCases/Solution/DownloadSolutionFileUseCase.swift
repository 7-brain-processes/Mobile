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
