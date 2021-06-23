//
//  Recommendation.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/22/21.
//

import Foundation

struct Recommendations: Codable {
    
    public let event: Event
    public let state: String?
    
    private enum CodingKeys: String, CodingKey {
        case event
        case state
    }
    
}
