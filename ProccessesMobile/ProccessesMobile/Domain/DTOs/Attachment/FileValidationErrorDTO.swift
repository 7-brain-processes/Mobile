//
//  FileValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum FileValidationErrorDTO: Error, Equatable, Sendable {
    case emptyId(String)
    case emptyFileData
    case invalidFileName
}
