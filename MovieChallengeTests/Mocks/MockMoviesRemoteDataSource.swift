//
//  MockMoviesRemoteDataSource.swift
//  MovieChallengeTests
//
//  Created by Carlos Kimura on 16/09/26.
//

import Foundation
@testable import MovieChallenge

final class MockMoviesRemoteDataSource: MoviesRemoteDataSourceProtocol {
    
    var moviesToReturn: [MovieDTO] = []
    var errorToThrow: Error?
    
    private(set) var fetchPopularMoviesCallCount = 0
    
    func fetchPopularMovies() async throws -> [MovieDTO] {
        fetchPopularMoviesCallCount += 1
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        return moviesToReturn
    }
}
