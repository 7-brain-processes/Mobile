//
//  TokenStorage.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


import Foundation

protocol TokenStorage: AccessTokenProvider {

    func saveToken(_ token: String) throws

    func getToken() throws -> String?

    func clear() throws
}

extension TokenStorage {

    func accessToken() throws -> String? {
        try getToken()
    }
}
