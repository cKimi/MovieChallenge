//
//  MoviesViewModelTests.swift
//  MovieChallengeTests
//
//  Created by Carlos Kimura on 16/09/26.
//

import Testing
@testable import MovieChallenge

@MainActor
struct MoviesViewModelTests {
    
    @Test
    func loadMovies_whenRepositorySucceeds_shouldLoadMovies() async {
        // Given
        let repository = MockMoviesRepository()
        
        repository.moviesToReturn = [
            Movie(
                id: 1,
                title: "Interstellar",
                overview: "A science fiction movie",
                posterPath: "/interstellar.jpg",
                rating: 8.7,
                releaseDate: "2014-11-07"
            )
        ]
        
        let sut = MoviesViewModel(repository: repository)
        
        var receivedStates: [MoviesViewState] = []
        
        sut.onStateChanged = { state in
            receivedStates.append(state)
        }
        
        // When
        await sut.loadMovies()
        
        // Then
        #expect(repository.fetchPopularMoviesCallCount == 1)
        #expect(sut.numberOfMovies == 1)
        #expect(receivedStates == [
            .loading,
            .loaded
        ])
        
        let item = sut.item(at: 0)
        
        #expect(item.title == "Interstellar")
        #expect(item.rating == "★ 8.7")
    }
    
    @Test
    func loadMovies_whenRepositoryFails_shouldEmitErrorState() async {
        // Given
        let repository = MockMoviesRepository()
        repository.errorToThrow = TestError.somethingWentWrong
        
        let sut = MoviesViewModel(repository: repository)
        
        var receivedStates: [MoviesViewState] = []
        
        sut.onStateChanged = { state in
            receivedStates.append(state)
        }
        
        // When
        await sut.loadMovies()
        
        // Then
        #expect(repository.fetchPopularMoviesCallCount == 1)
        #expect(receivedStates == [
            .loading,
            .error("Unable to load movies.")
        ])
        #expect(sut.numberOfMovies == 0)
    }
}
