//
//  EventTableViewCell.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/18/21.
//

import Foundation
import UIKit
import CoreData

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var favoriteHeartImage: UIImageView!
    
    func setupEventTableViewCell(event: Event, favoritedEventIDs: [NSManagedObject]) {
        // Setup labels
        eventLabel.text = event.title
        locationLabel.text = event.formatLocation()
        dateTimeLabel.text = event.formatDateTime()
        
        // Setup event image
        eventImage.loadImage(from: event.performers.first!.image!)
        
        // Setup favorite heart
        var favorited = false
        for eventID in favoritedEventIDs {
            if eventID.value(forKeyPath: "eventID") as? Int == event.id {
                favorited = true
            }
        }
        
        if !favorited {
            favoriteHeartImage.isHidden = true
        }
        else {
            favoriteHeartImage.isHidden = false
        }
        
        // Add word wrapping to labels
        setupWordWrapping()
    }
    
    func setupWordWrapping() {
        eventLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        dateTimeLabel.numberOfLines = 0
    }
    
    func roundImageCorners() {
        eventImage.layer.cornerRadius = 8.0
        eventImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundImageCorners()
    }
}
