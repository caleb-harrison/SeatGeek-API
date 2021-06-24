//
//  Recommendation.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/22/21.
//

import Foundation

/// Recommended event retrieved by favorited event and location
struct Recommendation: Codable {
    
    /// Recommended event
    public let event: Event
    
    /// Score of recommended event
    public let score: Int
    
    private enum CodingKeys: String, CodingKey {
        case event
        case score
    }
    
}

/// Array of all recommended events gathered
struct Recommendations: Codable {
    let recommendations: [Recommendation]
}
