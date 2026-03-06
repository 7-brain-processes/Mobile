//
//  FileValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//



public enum FileValidationError: Error, Equatable, Sendable {
    case emptyId(String)
    case emptyFileData
    case invalidFileName
}