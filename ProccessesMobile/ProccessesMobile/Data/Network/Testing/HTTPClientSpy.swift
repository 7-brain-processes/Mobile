//
//  HTTPClientSpy.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

final class HTTPClientSpy: HTTPClient, @unchecked Sendable {

    private let lock = NSLock()

    private var stubs: [Result<(Data, HTTPURLResponse), Error>] = []

    private var recordedRequests: [URLRequest] = []

    func addStub(_ stub: Result<(Data, HTTPURLResponse), Error>) {

        lock.lock()
        stubs.append(stub)
        lock.unlock()
    }

    func getRecordedRequests() -> [URLRequest] {

        lock.lock()
        defer { lock.unlock() }

        return recordedRequests
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {

        let stub: Result<(Data, HTTPURLResponse), Error> = lock.withLock {

            recordedRequests.append(request)

            guard !stubs.isEmpty else {
                fatalError("HTTPClientSpy received request without stub")
            }

            return stubs.removeFirst()
        }

        return try stub.get()
    }
}

private extension NSLock {

    func withLock<T>(_ block: () -> T) -> T {
        lock()
        defer { unlock() }
        return block()
    }
}
