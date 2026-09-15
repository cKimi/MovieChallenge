//
//  MovieCell.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 14/09/26.
//

import UIKit

@MainActor
final class MovieCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieCell"
    
    private var imageTask: Task<Void, Never>?
    
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageTask?.cancel()
        imageTask = nil
        
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
    }
    
    func configure(title: String, rating: String, posterPath: String?) {
        titleLabel.text = title
        ratingLabel.text = rating
        
        posterImageView.image = nil
        
        imageTask?.cancel()
        
        guard let posterPath else { return }
        
        let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
        guard let url = URL(string: urlString) else { return }
        
        imageTask = Task { [weak self] in
            do {
                let image = try await ImageLoader.shared.loadImage(from: url)
                
                guard !Task.isCancelled else { return }
                self?.posterImageView.image = image
            } catch {
                guard !Task.isCancelled else { return }
                print("Failed to load poster: \(error)")
            }
        }
    }
    
    private func setupView() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}
