//
//  DetailViewController.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/18/21.
//

import UIKit

class DetailViewController: UIViewController {

    var favoritedEvent: Bool!
    
    var eventName: String!
    var dateTime: String!
    var location: String!
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var eventImage: UIImageView!
    
    @IBOutlet var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteButton()
        setupWordWrapping()
        setLabels()
    }
    
    func setupFavoriteButton() {
        if (favoritedEvent) {
            // Show red heart
            favoriteButton.setImage(UIImage(named: "heartFill"), for: .normal)
            favoriteButton.tintColor = UIColor.systemRed
        } else {
            // Show empty heart
            favoriteButton.setImage(UIImage(named: "heartFill"), for: .normal)
            favoriteButton.tintColor = UIColor.label
        }
    }
    
    func setLabels() {
        eventLabel.text = "Miami Hurricanes at Alabama Crimson Tide Football"
        dateTimeLabel.text = "Thursday, August 31, 2021 10:00 PM"
        locationLabel.text = "Tuscaloosa, AL"
    }
    
    func setupWordWrapping() {
        eventLabel.numberOfLines = 0
        dateTimeLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
    }
    
    @IBAction func backButtonClicked() {
        self.dismiss(animated: true, completion: {
            // reload table view data and check if favorited
            // save to database?
        })
    }
    
}
