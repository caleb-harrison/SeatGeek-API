//
//  LaunchScreenViewController.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/21/21.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 261, height: 200))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "SeatGeek-Logo")
        return imageView
    }()
    
    func animate() {
        // Zoom in
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2.5
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX / 2),
                y: (diffY / 2),
                width: size,
                height: size
            )
        })
        
        // Fade opacity
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        }, completion: { done in
            
            // Present home screen
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    self.performSegue(withIdentifier: "GoToHome", sender: self)
                })
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        // Delay animation
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
}
