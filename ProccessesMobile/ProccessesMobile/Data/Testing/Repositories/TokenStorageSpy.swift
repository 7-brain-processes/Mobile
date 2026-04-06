//
//  TokenStorageFake.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

final class TokenStorageSpy: TokenStorage, @unchecked Sendable {
    private let lock = NSLock()
    private var _savedToken: String?
    private var _saveCallCount = 0
    
    func getSavedToken() -> String? {
        lock.lock(); defer { lock.unlock() }
        return _savedToken
    }
    
    func getSaveCallCount() -> Int {
        lock.lock(); defer { lock.unlock() }
        return _saveCallCount
    }
    
    func saveToken(_ token: String) throws {
        lock.lock(); defer { lock.unlock() }
        _savedToken = token
        _saveCallCount += 1
    }
    
    func getToken() throws -> String? {
        return getSavedToken()
    }
    
    func clear() throws {
        lock.lock(); defer { lock.unlock() }
        _savedToken = nil
    }
}
