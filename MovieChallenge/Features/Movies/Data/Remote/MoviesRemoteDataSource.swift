//
//  MoviesRemoteDataSource.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import Foundation

final class MoviesRemoteDataSource: MoviesRemoteDataSourceProtocol {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchPopularMovies() async throws -> [MovieDTO] {
        guard let url = URL(
            string: "https://api.themoviedb.org/3/movie/popular"
        ) else {
            throw URLError(.badURL)
        }
        
        guard let token = Bundle.main.object(
            forInfoDictionaryKey: "TMDB_ACCESS_TOKEN"
        ) as? String, !token.isEmpty, token != "$(TMDB_ACCESS_TOKEN" else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await httpClient.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let responseDTO = try decoder.decode(MoviesResponseDTO.self, from: data)
        return responseDTO.results
    }
}
