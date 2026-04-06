//
//  DefaultDeletePostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

struct DefaultDeletePostMaterialUseCase: DeletePostMaterialUseCase {
    let repository: PostMaterialsRepository

    func execute(_ command: DeletePostMaterialCommand) async throws {
        try await repository.deleteMaterial(command)
    }
}
