//
//  AccessTokenProvider.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


import Foundation

protocol AccessTokenProvider: Sendable {
    func accessToken() throws -> String?
}
