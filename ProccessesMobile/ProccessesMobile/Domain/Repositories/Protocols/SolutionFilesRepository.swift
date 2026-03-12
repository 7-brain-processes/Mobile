//
//  SolutionFilesRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol SolutionFilesRepository: Sendable {
    func listSolutionFiles(_ query: ListSolutionFilesQuery) async throws -> [AttachedFile]
    func uploadSolutionFile(_ command: UploadSolutionFileCommand) async throws -> AttachedFile
    func deleteSolutionFile(_ command: DeleteSolutionFileCommand) async throws
    func downloadSolutionFile(_ query: DownloadSolutionFileQuery) async throws -> Data
}
