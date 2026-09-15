//
//  MoviesRepositoryImpl.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import Foundation

final class MoviesRepositoryImpl: MoviesRepository {
    
    private let remoteDatasource: MoviesRemoteDataSourceProtocol
    
    init(remoteDataSource: MoviesRemoteDataSourceProtocol) {
        self.remoteDatasource = remoteDataSource
    }
    
    func fetchPopularMovies() async throws -> [Movie] {
        let dtos = try await remoteDatasource.fetchPopularMovies()
        return dtos.map { $0.toDomain() }
    }
}
