//
//  MoviesViewController.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 14/09/26.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    override func loadView() {
        view = MoviesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
    }
}
