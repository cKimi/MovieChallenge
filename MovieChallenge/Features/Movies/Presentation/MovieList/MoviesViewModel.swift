//
//  MoviesViewModel.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 14/09/26.
//

import Foundation

final class MoviesViewModel {
    
    private let movies: [Movie] = [
        Movie(title: "The GodFather", rating: 9.2),
        Movie(title: "The Dark Knight", rating: 9.0),
        Movie(title: "Interstellar", rating: 8.7),
        Movie(title: "Inception", rating: 8.8),
        Movie(title: "Parasite", rating: 8.5),
        Movie(title: "Whiplash", rating: 8.5)
    ]
    
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
}
