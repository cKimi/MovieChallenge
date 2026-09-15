//
//  MoviesRemoteDataSourceProtocol.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import Foundation

protocol MoviesRemoteDataSourceProtocol {
    func fetchPopularMovies() async throws -> [MovieDTO]
}
