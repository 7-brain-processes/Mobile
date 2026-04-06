//
//  EndpointBody.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum EndpointBody {
    case json(Encodable)
    case raw(Data, contentType: String?)
    case none
}
