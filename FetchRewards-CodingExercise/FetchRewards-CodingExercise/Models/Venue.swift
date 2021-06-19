//
//  Venue.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/19/21.
//

import Foundation

struct Venue: Codable {
    
    let city: String
    let name: String
    let extended_address: String
    let url: String
    let country: String
    let state: String
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case city
        case name
        case extended_address
        case url
        case country
        case state
        case id
    }
    
}

/*
"venue": {
    "city": "New York",
    "name": "Terminal 5",
    "extended_address": null,
    "url": "https://seatgeek.com/terminal-5-tickets/",
    "country": "US",
    "state": "NY",
    "score": 149.259,
    "postal_code": "10019",
    "location": {
        "lat": 40.77167,
        "lon": -73.99277
    },
    "address": null,
    "id": 814
 }
 */
