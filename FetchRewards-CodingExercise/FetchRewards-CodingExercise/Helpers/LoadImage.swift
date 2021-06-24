//
//  LoadImage.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/20/21.
//

import UIKit

extension UIImageView {
    
    /// Creates URL from link and gathers event image from URL
    /// - Parameters:
    ///   - link: link to event image
    ///   - mode: image view's content mode
    func loadImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        loadImageFromURL(from: url, contentMode: mode)
    }
    
    /// Loads event image from URL and sets event.image
    /// - Parameters:
    ///   - url: URL to event image
    ///   - mode: image view's content mode
    func loadImageFromURL(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }
        
        task.resume()
    }
    
}
