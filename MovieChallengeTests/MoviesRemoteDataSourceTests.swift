//
//  MoviesRemoteDataSourceTests.swift
//  MovieChallengeTests
//
//  Created by Carlos Kimura on 16/09/26.
//

import Foundation
import Testing
@testable import MovieChallenge

@MainActor
struct MoviesRemoteDataSourceTests {
    
    
    @Test
    func fetchPopularMovies_whenResponseIsSuccessful_shouldReturnDecodedMovies() async throws {
        // Given
        let httpClient = MockHTTPClient()
        
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Interstellar",
                    "overview": "A science fiction movie",
                    "poster_path": "/interstellar.jpg",
                    "vote_average": 8.7,
                    "release_date": "2014-11-07"
                }
            ],
            "total_pages": 500,
            "total_results": 10000
        }
        """
        
        httpClient.dataToReturn = Data(json.utf8)
        
        let url = try #require(URL(string: "https://api.themoviedb.org/3/movie/popular"))
        
        httpClient.responseToReturn = try #require(
            HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        let sut = MoviesRemoteDataSource(httpClient: httpClient)
        
        // When
        let movies = try await sut.fetchPopularMovies()
        
        // Then
        #expect(httpClient.dataCallCount == 1)
        #expect(movies.count == 1)
        
        let movie = movies[0]
        
        #expect(movie.id == 1)
        #expect(movie.title == "Interstellar")
        #expect(movie.overview == "A science fiction movie")
        #expect(movie.posterPath == "/interstellar.jpg")
        #expect(movie.voteAverage == 8.7)
        #expect(movie.releaseDate == "2014-11-07")
    }
    
    @Test
    func fetchPopularMovies_whenResponseIsNotSuccessful_shouldThrowError() async {
        // Given
        let httpClient = MockHTTPClient()
        let url = try! #require(URL(string: "https://api.themoviedb.org/3/movie/popular"))
        
        httpClient.dataToReturn = Data()
        
        httpClient.responseToReturn = try! #require(
            HTTPURLResponse(
                url: url,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        let sut = MoviesRemoteDataSource(httpClient: httpClient)
        
        // When / Then
        await #expect(throws: Error.self) {
            try await sut.fetchPopularMovies()
        }
        
        #expect(httpClient.dataCallCount == 1)
    }
    
    @Test
    func fetchPopularMovies_whenHTTPClientFails_shouldThrowError() async {
        // Given
        let httpClient = MockHTTPClient()
        httpClient.errorToThrow = TestError.somethingWentWrong
        
        let sut = MoviesRemoteDataSource(httpClient: httpClient)
        
        // When / Then
        await #expect(throws: TestError.somethingWentWrong) {
            try await sut.fetchPopularMovies()
        }
        
        #expect(httpClient.dataCallCount == 1)
    }
    
    @Test
    func fetchPopularMovies_whenResponseContainsInvalidJSON_shouldThrowDecodingError() async {
        // Given
        let httpClient = MockHTTPClient()
        
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Interstellar"
                }
            ],
            "total_pages": 500,
            "total_results": 10000
        }
        """
        
        httpClient.dataToReturn = Data(json.utf8)
        
        let url = try! #require(URL(string: "https://api.themoviedb.org/3/movie/popular"))
        
        httpClient.responseToReturn = try! #require(
            HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
        )
        
        let sut = MoviesRemoteDataSource(httpClient: httpClient)
        
        // When / Then
        await #expect(throws: DecodingError.self) {
            try await sut.fetchPopularMovies()
        }
        
        #expect(httpClient.dataCallCount == 1)
    }
}
