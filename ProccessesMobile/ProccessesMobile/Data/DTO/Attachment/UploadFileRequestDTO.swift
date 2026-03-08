//
//  UploadFileRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct UploadFileRequestDTO: Equatable, Sendable {
    let fileName: String
    let mimeType: String
    let data: String
    
    init(fileName: String, mimeType: String, data: String) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}
