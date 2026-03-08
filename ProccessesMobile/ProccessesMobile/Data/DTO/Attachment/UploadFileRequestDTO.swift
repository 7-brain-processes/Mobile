//
//  UploadFileRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Foundation

struct UploadFileRequestDTO: Equatable, Sendable {
    let fileName: String
    let mimeType: String
    let data: Data
}
