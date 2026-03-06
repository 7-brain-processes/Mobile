//
//  TokenStorage.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol TokenStorage: Sendable {
    func saveToken(_ token: String) throws
    func getToken() throws -> String?
    func deleteToken() throws
}
