//
//  DownloadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol DownloadPostMaterialUseCase: Sendable {
    func execute(_ query: DownloadPostMaterialQuery) async throws -> Data
}
