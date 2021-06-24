//
//  Stats.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/19/21.
//

import Foundation

/// Statistics of event's tickets
struct Stats: Codable {
    
    public let listing_count: Int?
    
    /// Average price of ticket for event
    public let average_price: Int?
    
    /// Lowest price of ticket for event
    public let lowest_price: Int?
    
    /// Highest price of ticket for event
    public let highest_price: Int?
    
    private enum CodingKeys: String, CodingKey {
        case listing_count
        case average_price
        case lowest_price
        case highest_price
    }
    
}
