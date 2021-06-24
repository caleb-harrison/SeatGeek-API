//
//  Venue.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/19/21.
//

import Foundation

/// Venue of event
struct Venue: Codable {
    
    /// City of event venue
    public let city: String?
    
    /// State of event venue
    public let state: String?
    
    private enum CodingKeys: String, CodingKey {
        case city
        case state
    }
    
}
