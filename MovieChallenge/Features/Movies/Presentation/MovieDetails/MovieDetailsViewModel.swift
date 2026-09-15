//
//  MovieDetailsViewModel.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import Foundation

final class MovieDetailsViewModel {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String {
        movie.title
    }
    
    var rating: String {
        "★ \(movie.rating)"
    }
}
