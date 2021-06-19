//
//  Event.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/19/21.
//

import Foundation

struct Event: Codable {
    
    // Summary information about currently available ticket listings for the event
    //let stats: Stats
    
    // The title of the event
    let title: String
    
    // URL of the event on seatgeek.com – you should direct users here to search for tickets
    let url: String
    
    // Date/time of the event in the local timezone of the venue – you will generally want to display this to users
    let datetime_local: String
    
    // An list of performers – primary, home_team, away_team fields indicate the performer's role at the event
    let performers: [Performer]
    
    // A venue response document
    let venue: Venue
    
    // A shortened title for the event
    let short_title: String
    
    // Date and time of the event in UTC
    let datetime_utc: String
    
    // A numerical representation of popularity based on ticket sales
    let score: Float
    
    // Type of event
    let type: String
    
    // A unique integer identifier for the event
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        //case stats
        case title
        case url
        case datetime_local
        case performers
        case venue
        case short_title
        case datetime_utc
        case score
        case type
        case id
    }
    
}

struct Events: Codable {
    let events: [Event]
}
