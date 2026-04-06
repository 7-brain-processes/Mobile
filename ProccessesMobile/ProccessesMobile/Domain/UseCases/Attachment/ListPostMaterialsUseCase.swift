//
//  ListPostMaterialsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol ListPostMaterialsUseCase: Sendable {
    func execute(_ query: ListPostMaterialsQuery) async throws -> [AttachedFile]
}
