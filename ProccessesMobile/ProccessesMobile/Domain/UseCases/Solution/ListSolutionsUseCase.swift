//
//  ListSolutionsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol ListSolutionsUseCase: Sendable {
    func execute(_ query: ListSolutionsQuery) async throws -> Page<Solution>
}
