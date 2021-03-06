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
    
    /// Sets up each event's table view cell with gathered information
    /// - Parameters:
    ///   - event: gathered event from API
    ///   - favoritedEventIDs: event ID's from favorited events (if any)
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
        
        if #available(iOS 13.0, *) {
            favoriteHeartImage.image = UIImage(systemName: "heart.fill")
        } else {
            // Fallback on earlier versions
            favoriteHeartImage.image = UIImage(named: "Heart-Fill")
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
    
    /// Sets up word wrapping for labels of various length
    func setupWordWrapping() {
        eventLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        dateTimeLabel.numberOfLines = 0
    }
    
    /// Adds rounded image corners to each table view cell's event image
    func roundImageCorners() {
        eventImage.layer.cornerRadius = 8.0
        eventImage.clipsToBounds = true
    }
    
    /// Calls custom layout functions
    override func layoutSubviews() {
        super.layoutSubviews()
        roundImageCorners()
    }
}
