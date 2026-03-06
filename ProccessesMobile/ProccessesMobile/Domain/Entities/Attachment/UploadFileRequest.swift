//
//  UploadFileRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct UploadFileRequest: Equatable, Sendable {
    public let fileName: String
    public let mimeType: String
    public let data: Data
    
    public init(fileName: String, mimeType: String, data: Data) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}
