//
//  AppCoordinator.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMovies()
    }
    
    private func showMovies() {
        let viewModel = MoviesViewModel()
        let viewController = MoviesViewController(viewModel: viewModel)
        
        viewController.onMovieSelected = { [weak self] movie in
            self?.showMovieDetails(movie)
        }
        
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showMovieDetails(_ movie: Movie) {
        let viewModel = MovieDetailsViewModel(movie: movie)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
