//
//  Event.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/19/21.
//

import Foundation

struct Event: Codable {
    
    // Summary information about currently available ticket listings for the event
    let stats: Stats?
    
    // The title of the event
    let title: String
    
    // URL of the event on seatgeek.com – you should direct users here to search for tickets
    let url: String
    
    // Date/time of the event in the local timezone of the venue – you will generally want to display this to users
    let datetime_local: String
    
    // Returns bool if date/time is determined
    let time_tbd: Bool
    let date_tbd: Bool
    
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
        case stats
        case title
        case url
        case datetime_local
        case time_tbd
        case date_tbd
        case performers
        case venue
        case short_title
        case datetime_utc
        case score
        case type
        case id
    }
    
    func formatDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: datetime_local)
        var dateTimeString: String!
        
        if date_tbd && time_tbd {
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            dateTimeString = "\(dateFormatter.string(from: date!))\nTime: TBD"
        } else if date_tbd && !time_tbd {
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy\nh:mm a"
            dateTimeString = dateFormatter.string(from: date!)
        } else if time_tbd {
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            dateTimeString = dateFormatter.string(from: date!)
            dateTimeString.append("\nTime: TBD")
        } else {
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy\nh:mm a"
            dateTimeString = dateFormatter.string(from: date!)
        }
        
        return dateTimeString
    }
    
    func formatLocation() -> String {
        // Null safety
        let city = ( venue.city != nil ? venue.city! : "" )
        let state = ( venue.state != nil ? venue.state! : "" )
        
        // Format location based on possible null values
        if (city != "" && state != "") {
            return "\(city), \(state)"
        } else if (city == "" && state != "") {
            return "\(state)"
        } else if (city != "" && state == "") {
            return "\(city)"
        } else {
            return "Location: TBD"
        }
    }
    
}

struct Events: Codable {
    let events: [Event]
}
