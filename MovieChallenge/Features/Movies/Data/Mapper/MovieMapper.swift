//
//  MovieMapper.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import Foundation

extension MovieDTO {
    
    func toDomain() -> Movie {
        Movie(id: id, title: title, overview: overview, posterPath: posterPath, rating: voteAverage, releaseDate: releaseDate)
    }
}
