//
//  PostMaterialsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol PostMaterialsRepository: Sendable {
    func listMaterials(courseId: String, postId: String) async throws -> [AttachedFile]
    func uploadMaterial(courseId: String, postId: String, request: UploadFileRequest) async throws -> AttachedFile
    func deleteMaterial(courseId: String, postId: String, fileId: String) async throws
    func downloadMaterial(courseId: String, postId: String, fileId: String) async throws -> Data
}
