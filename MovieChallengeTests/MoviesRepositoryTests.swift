//
//  MoviesRepositoryTests.swift
//  MovieChallengeTests
//
//  Created by Carlos Kimura on 16/09/26.
//

import Testing
@testable import MovieChallenge

@MainActor
struct MoviesRepositoryTests {
    
    @Test
    func fetchPopularMovies_whenRemoteDataSourceSucceeds_shouldReturnMappedMovies() async throws {
        // Given
        let remoteDataSource = MockMoviesRemoteDataSource()
        
        remoteDataSource.moviesToReturn = [
            MovieDTO(id: 1,
                     title: "Interstellar",
                     overview: "A science fiction movie",
                     posterPath: "/interstellar.jpg",
                     voteAverage: 8.7,
                     releaseDate: "2014-11-07"
                    )
        ]
        
        let sut = MoviesRepositoryImpl(remoteDataSource: remoteDataSource)
        
        // When
        let movies = try await sut.fetchPopularMovies()
        
        // Then
        #expect(remoteDataSource.fetchPopularMoviesCallCount == 1)
        #expect(movies.count == 1)
        
        let movie = movies[0]
        
        #expect(movie.id == 1)
        #expect(movie.title == "Interstellar")
        #expect(movie.overview == "A science fiction movie")
        #expect(movie.posterPath == "/interstellar.jpg")
        #expect(movie.rating == 8.7)
        #expect(movie.releaseDate == "2014-11-07")
    }
    
    @Test
    func fetchPopularMovies_whenRemoteDataSourceFails_shouldThrowError() async {
        // Given
        let remoteDataSource = MockMoviesRemoteDataSource()
        remoteDataSource.errorToThrow = TestError.somethingWentWrong
        
        let sut = MoviesRepositoryImpl(remoteDataSource: remoteDataSource)
        
        // When / Then
        do {
            _ = try await sut.fetchPopularMovies()
            Issue.record("Expected fetchPopularMovies() to throw an error")
        } catch {
            #expect(remoteDataSource.fetchPopularMoviesCallCount == 1)
            #expect(error as? TestError == .somethingWentWrong)
        }
    }
}
