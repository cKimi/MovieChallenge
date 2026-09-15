//
//  MoviesRepository.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import Foundation

protocol MoviesRepository {
    func fetchPopularMovies() async throws -> [Movie]
}
