//
//  UploadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol UploadPostMaterialUseCase: Sendable {
    func execute(_ command: UploadPostMaterialCommand) async throws -> AttachedFile
}
