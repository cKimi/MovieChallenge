//
//  MoviesViewModel.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 14/09/26.
//

import Foundation

@MainActor
final class MoviesViewModel {
    
    private let repository: MoviesRepository
    private var movies: [Movie] = []
    
    var onStateChanged: ((MoviesViewState) -> Void)?
    
    private(set) var state: MoviesViewState = .idle {
        didSet {
            onStateChanged?(state)
        }
    }
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    var numberOfMovies: Int {
        movies.count
    }
    
    func item(at index: Int) -> MovieCellViewData {
        let movie = movies[index]
        return MovieCellViewData(title: movie.title, rating: "★ \(movie.rating)")
    }
    
    func movie(at index: Int) -> Movie {
        movies[index]
    }
    
    func loadMovies() async {
        state = .loading
        
        do {
            movies = try await repository.fetchPopularMovies()
            state = .loaded
        } catch {
            state = .error("Unable to load movies.")
        }
    }
}
