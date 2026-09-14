//
//  MoviesViewController.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 14/09/26.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    private let viewModel: MoviesViewModel
    
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
    }
    
    private func setupCollectionView() {
        contentView.moviesCollectionView.dataSource = self
        contentView.moviesCollectionView.delegate = self
        
        contentView.moviesCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
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
        cell.configure(title: item.title, rating: item.rating)
        
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
}
