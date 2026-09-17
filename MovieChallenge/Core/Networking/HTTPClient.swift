//
//  HTTPClient.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 16/09/26.
//

import Foundation

protocol HTTPClient {
    func data(for requests: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient { }
