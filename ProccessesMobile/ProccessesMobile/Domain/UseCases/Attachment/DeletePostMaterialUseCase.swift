//
//  DeletePostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

protocol DeletePostMaterialUseCase: Sendable {
    func execute(_ command: DeletePostMaterialCommand) async throws
}
