//
//  MoviesViewController.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 14/09/26.
//

import UIKit

@MainActor
final class MoviesViewController: UIViewController {
    
    private let viewModel: MoviesViewModel
    var onMovieSelected: ((Movie) -> Void)?
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var contentView: MoviesView {
        guard let view = view as? MoviesView else {
            fatalError("Expected MoviesView as root view")
        }
        
        return view
    }
    
    override func loadView() {
        view = MoviesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
        setupCollectionView()
        bindViewModel()
        loadMovies()
    }
    
    private func setupCollectionView() {
        contentView.moviesCollectionView.dataSource = self
        contentView.moviesCollectionView.delegate = self
        
        contentView.moviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.render(state)
        }
    }
    
    private func loadMovies() {
        Task {
            await viewModel.loadMovies()
        }
    }
    
    private func render(_ state: MoviesViewState) {
        switch state {
        case .idle:
            contentView.setLoading(false)
            
        case .loading:
            contentView.setLoading(true)
            
        case .loaded:
            contentView.setLoading(false)
            contentView.moviesCollectionView.reloadData()
            
        case .error(let message):
            contentView.setLoading(false)
            print("Error: \(message)")
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
            fatalError("Unable to dequeue MovieCell")
        }
        
        let item = viewModel.item(at: indexPath.item)
        cell.configure(title: item.title, rating: item.rating, posterPath: item.posterPath)
        
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12
        let totalSpacing = spacing
        let width = (collectionView.bounds.width - totalSpacing) / 2
        
        return CGSize(width: width, height: width * 1.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movie(at: indexPath.item)
        onMovieSelected?(movie)
    }
}
