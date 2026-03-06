//
//  HTTPClientSpy.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public final class HTTPClientSpy: HTTPClient, @unchecked Sendable {
    private let lock = NSLock()
    
    private var _stubs: [Result<(Data, HTTPURLResponse), Error>] = []
    private var _recordedRequests: [URLRequest] = []
    
    public init() {}
    
    public func addStub(_ stub: Result<(Data, HTTPURLResponse), Error>) {
        lock.withLock {
            _stubs.append(stub)
        }
    }
    
    public func getRecordedRequests() -> [URLRequest] {
        lock.withLock {
            return _recordedRequests
        }
    }
    
    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let stubToReturn = lock.withLock { () -> Result<(Data, HTTPURLResponse), Error> in
            _recordedRequests.append(request)
            
            guard !_stubs.isEmpty else {
                fatalError("HTTPClientSpy received a request but had no stubs configured!")
            }
            
            return _stubs.removeFirst()
        }
        
        return try stubToReturn.get()
    }
}
