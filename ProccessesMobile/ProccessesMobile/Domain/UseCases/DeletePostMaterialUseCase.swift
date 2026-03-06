//
//  DeletePostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol DeletePostMaterialUseCase: Sendable { func execute(courseId: String, postId: String, fileId: String) async throws }