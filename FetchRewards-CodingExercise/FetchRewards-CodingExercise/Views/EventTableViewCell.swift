//
//  EventTableViewCell.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/18/21.
//

import Foundation
import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    
    @IBOutlet var eventImage: UIImageView!
    
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
