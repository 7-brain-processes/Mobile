//
//  AttachedFile+FeedAttachmentItem.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    var detectedMimeType: String {
        if let type = UTType(filenameExtension: pathExtension),
           let mime = type.preferredMIMEType {
            return mime
        }
        return "application/octet-stream"
    }
}
