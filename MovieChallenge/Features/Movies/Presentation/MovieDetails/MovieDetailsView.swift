//
//  MovieDetailsView.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import UIKit

final class MovieDetailsView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    func configure(title: String, rating: String) {
        titleLabel.text = title
        ratingLabel.text = rating
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(titleLabel)
        addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
}
