//
//  UploadFileRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct UploadFileRequest: Equatable, Sendable {
    let fileName: String
    let mimeType: String
    let data: Data
    
    init(fileName: String, mimeType: String, data: Data) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}
