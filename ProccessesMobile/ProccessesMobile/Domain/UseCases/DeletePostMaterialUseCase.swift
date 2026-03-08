//
//  DeletePostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


protocol DeletePostMaterialUseCase: Sendable { func execute(courseId: String, postId: String, fileId: String) async throws }