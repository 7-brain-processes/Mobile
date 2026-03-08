//
//  SolutionFilesRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol SolutionFilesRepository: Sendable {
    func listSolutionFiles(courseId: String, postId: String, solutionId: String) async throws -> [AttachedFile]
    func uploadSolutionFile(courseId: String, postId: String, solutionId: String, request: UploadFileRequest) async throws -> AttachedFile
    func deleteSolutionFile(courseId: String, postId: String, solutionId: String, fileId: String) async throws
    func downloadSolutionFile(courseId: String, postId: String, solutionId: String, fileId: String) async throws -> Data
}
