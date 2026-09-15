//
//  ImageLoader.swift
//  MovieChallenge
//
//  Created by Carlos Kimura on 15/09/26.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() { }
    
    func loadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        cache.setObject(image, forKey: url as NSURL)
        
        return image
    }
}
