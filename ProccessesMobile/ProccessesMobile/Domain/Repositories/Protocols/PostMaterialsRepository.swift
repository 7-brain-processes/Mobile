//
//  PostMaterialsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol PostMaterialsRepository: Sendable {
    func listMaterials(_ query: ListPostMaterialsQuery) async throws -> [AttachedFile]
    func uploadMaterial(_ command: UploadPostMaterialCommand) async throws -> AttachedFile
    func deleteMaterial(_ command: DeletePostMaterialCommand) async throws
    func downloadMaterial(_ query: DownloadPostMaterialQuery) async throws -> Data
}
