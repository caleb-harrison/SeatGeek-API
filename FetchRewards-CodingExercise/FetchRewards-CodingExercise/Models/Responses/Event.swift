//
//  Event.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/19/21.
//

import Foundation

/// SeatGeek event
struct Event: Codable {
    
    /// Summary information about currently available ticket listings for the event
    public let stats: Stats?
    
    /// The title of the event
    public let title: String
    
    /// URL of the event on seatgeek.com – you should direct users here to search for tickets
    public let url: String
    
    /// Date/time of the event in the local timezone of the venue – you will generally want to display this to users
    public let datetime_local: String
    
    /// If time is determined
    public let time_tbd: Bool
    
    /// If date is determined
    public let date_tbd: Bool
    
    /// List of performers
    public let performers: [Performer]
    
    /// Event venue
    public let venue: Venue
    
    /// A shortened title for the event
    public let short_title: String
    
    /// Date and time of the event in UTC
    public let datetime_utc: String
    
    /// A numerical representation of popularity based on ticket sales
    public let score: Float
    
    /// Type of event
    public let type: String
    
    /// A unique integer identifier for the event
    public let id: Int
    
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
    
    /// Formats date and time for label
    /// - Returns: formatted date and time
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
    
    /// Formats location for label
    /// - Returns: formatted location
    func formatLocation() -> String {
        // Null safety
        let city = ( venue.city != nil ? venue.city! : "" )
        let state = ( venue.state != nil ? venue.state! : "" )
        
        // Format location
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


/// Array of events
struct Events: Codable {
    var events: [Event]
}
