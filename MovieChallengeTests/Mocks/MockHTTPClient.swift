//
//  MockHTTPClient.swift
//  MovieChallengeTests
//
//  Created by Carlos Kimura on 16/09/26.
//

import Foundation
@testable import MovieChallenge

final class MockHTTPClient: HTTPClient {
    
    var dataToReturn = Data()
    var responseToReturn: URLResponse?
    var errorToThrow: Error?
    
    private(set) var receivedRequest: URLRequest?
    private(set) var dataCallCount = 0
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataCallCount += 1
        receivedRequest = request
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        guard let responseToReturn else {
            throw URLError(.badServerResponse)
        }
        
        return (dataToReturn, responseToReturn)
    }
}
