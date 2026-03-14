//
//  FileValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum FileValidationError: Error, Equatable, Sendable {
    case emptyId(UUID)
    case emptyFileData
    case invalidFileName
}
