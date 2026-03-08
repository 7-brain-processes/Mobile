//
//  FileValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//



enum FileValidationError: Error, Equatable, Sendable {
    case emptyId(String)
    case emptyFileData
    case invalidFileName
}