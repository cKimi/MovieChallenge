//
//  MovieDetailsViewController.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    private let viewModel: MovieDetailsViewModel
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
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
    }
    
    private func setupView() {
        contentView.configure(title: viewModel.title, rating: viewModel.rating)
    }
}
