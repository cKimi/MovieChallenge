//
//  MoviesViewState.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import Foundation

enum MoviesViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
