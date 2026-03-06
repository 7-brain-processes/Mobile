//
//  DownloadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public protocol DownloadPostMaterialUseCase: Sendable { func execute(courseId: String, postId: String, fileId: String) async throws -> Data }
