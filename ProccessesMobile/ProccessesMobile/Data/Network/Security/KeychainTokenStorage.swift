//
//  KeychainTokenStorage.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//


import Foundation
import Security

final class KeychainTokenStorage: TokenStorage {

    private let accessTokenKey = "auth_access_token"
    private let refreshTokenKey = "auth_refresh_token"

    func saveTokens(accessToken: String, refreshToken: String) throws {
        try save(value: accessToken, for: accessTokenKey)
        try save(value: refreshToken, for: refreshTokenKey)
    }

    func saveToken(_ token: String) throws {
        try save(value: token, for: accessTokenKey)
    }

    func getToken() throws -> String? {
        try getValue(for: accessTokenKey)
    }

    func getRefreshToken() throws -> String? {
        try getValue(for: refreshTokenKey)
    }

    func clear() throws {
        try deleteValue(for: accessTokenKey)
        try deleteValue(for: refreshTokenKey)
    }
}

private extension KeychainTokenStorage {

    func save(value: String, for key: String) throws {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw APIError.invalidResponse
        }
    }

    func getValue(for key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?

        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw APIError.invalidResponse
        }

        guard
            let data = item as? Data,
            let value = String(data: data, encoding: .utf8)
        else {
            throw APIError.invalidResponse
        }

        return value
    }

    func deleteValue(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw APIError.invalidResponse
        }
    }
}
