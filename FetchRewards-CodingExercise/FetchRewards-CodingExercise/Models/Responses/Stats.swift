//
//  Stats.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/19/21.
//

import Foundation

struct Stats: Codable {
    
    let listing_count: Int?
    let average_price: Int?
    let lowest_price: Int?
    let highest_price: Int?
    
    private enum CodingKeys: String, CodingKey {
        case listing_count
        case average_price
        case lowest_price
        case highest_price
    }
}

/*
"stats": {
    "listing_count": 161,
    "average_price": 97,
    "lowest_price": 62,
    "highest_price": 296
}
*/
