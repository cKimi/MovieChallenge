//
//  MovieDetailsViewController.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    private let viewModel: MovieDetailsViewModel
    private let imageLoader: ImageLoader
    
    init(viewModel: MovieDetailsViewModel, imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    private var contentView: MovieDetailsView {
        guard let view = view as? MovieDetailsView else {
            fatalError("Expected MovieDetailsView as root view")
        }
        
        return view
    }
    
    override func loadView() {
        view = MovieDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadPoster()
    }
    
    private func setupView() {
        contentView.configure(title: viewModel.title, rating: viewModel.rating)
    }
    
    private func loadPoster() {
        guard let url = viewModel.posterURL else { return }
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let image = try await imageLoader.loadImage(from: url)
                guard !Task.isCancelled else { return }
                contentView.setPosterImage(image)
            } catch {
                print("Failed to load poster: \(error)")
            }
        }
    }
}
