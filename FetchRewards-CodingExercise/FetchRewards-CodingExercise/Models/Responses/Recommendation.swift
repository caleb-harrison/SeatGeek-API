//
//  Recommendation.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/22/21.
//

import Foundation

struct Recommendation: Codable {
    
    public let event: Event
    public let score: Int
    
    private enum CodingKeys: String, CodingKey {
        case event
        case score
    }
    
}

struct Recommendations: Codable {
    let recommendations: [Recommendation]
}
