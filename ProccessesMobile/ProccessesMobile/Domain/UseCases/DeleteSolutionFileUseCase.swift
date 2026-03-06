//
//  DeleteSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol DeleteSolutionFileUseCase: Sendable { func execute(courseId: String, postId: String, solutionId: String, fileId: String) async throws }