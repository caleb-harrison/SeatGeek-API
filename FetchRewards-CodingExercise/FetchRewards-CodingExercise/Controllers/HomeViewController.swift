//
//  ViewController.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/18/21.
//

import UIKit
import CoreData
import CoreLocation

/// Controller for the home screen
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {
    
    private var events = Events(events: [])
    private var recommendations = Recommendations(recommendations: [])
    private var favoritedEvents: [NSManagedObject] = []
    private var selectedIndex: Int!
    private var latitude: String = ""
    private var longitude: String = ""
    
    var locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    /// Client ID for SeatGeek API
    private let clientID = "MjIyODc5MzZ8MTYyNDA4ODc5NS4wNDIyNDMy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup searchbar
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavoritedEventIDs()
        
        // Ensures back button maintains same events as search
        if (favoritedEvents.count > 0 && (searchBar.text == "" || searchBar.text == nil) && latitude != "" && longitude != "") {
            getRecommendations()
        } else {
            searchEvents(url: createSearchURL(search: searchBar.text ?? ""))
        }
    }
    
    // MARK: - SeatGeek API Configuration
    
    /// Gets random events with no queries
    private func getEvents() {
        guard let url = URL(string: "https://api.seatgeek.com/2/events?client_id=\(clientID)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let eventsResponse = try decoder.decode(Events.self, from: data)
                self.events = eventsResponse
                print("Found \(self.events.events.count) random events")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error thrown while fetching data from SeatGeek API: \(error)")
            }
        }
        
        task.resume()
    }
    
    /// Gets recommended events based on user favorited event and user location
    private func getRecommendations() {
        let eventID: Int!
        
        if (favoritedEvents.count > 0 && latitude != "" && longitude != "") {
            eventID = favoritedEvents.first!.value(forKeyPath: "eventID") as? Int
            
            guard let url = URL(string: "https://api.seatgeek.com/2/recommendations?events.id=\( eventID!)&lat=\(latitude)&lon=\(longitude)&client_id=\(clientID)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    // Get recommendations
                    let decoder = JSONDecoder()
                    let recommendationResponse = try decoder.decode(Recommendations.self, from: data)
                    self.recommendations = recommendationResponse
                    
                    // Replace events with new recommended events
                    var recommendedEvents = [Event]()
                    for event in self.recommendations.recommendations {
                        recommendedEvents.append(event.event)
                    }
                    self.events.events = recommendedEvents
                    print("Found \(self.events.events.count) recommended events")
                    
                    // Reload tableview
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error {
                    print("Error thrown while fetching data from SeatGeek API: \(error)")
                }
            }
            
            task.resume()
            
        } else {
            print("No favorited events to get recommendations. Try favoriting an event to get recommendations.")
            searchEvents(url: createSearchURL(search: searchBar.text ?? ""))
        }
    }
    
    /// Gets favorited events and their corresponding event ID's
    private func getFavoritedEventIDs() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedEvent")
        
        do {
            favoritedEvents = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error thrown while fetching favorited events: \(error), \(error.userInfo)")
        }
    }
    
    /// Gets favorited events and prepends them to existing events
    // WORKING! Not using due to small bug with event insertion
    private func getFavoritedEvents() {
        if (self.favoritedEvents.count > 0) {
            
            for event in self.favoritedEvents {
                let eventID = event.value(forKeyPath: "eventID") as? Int
                
                guard let url = URL(string: "https://api.seatgeek.com/2/events?id=\(eventID!)&client_id=\(clientID)") else { return }
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let eventsResponse = try decoder.decode(Events.self, from: data)
                        self.events.events.insert(eventsResponse.events.first!, at: 0)
                        print("Inserted event: \(eventsResponse.events.first!.title)")
                    } catch let error {
                        print("Error thrown while fetching data from SeatGeek API: \(error)")
                    }
                }
                
                task.resume()
            }
        }
    }
    
    /// Creates search URL from string
    /// - Parameter search: value to search for through API
    /// - Returns: query search URL
    private func createSearchURL(search: String) -> URL {
        let query = "https://api.seatgeek.com/2/events?client_id=\(clientID)&q=\(search.replacingOccurrences(of: " ", with: "+").lowercased())"
        return URL(string: query)!
    }
    
    /// Search for events in SeatGeek API
    /// - Parameter url: URL to search for events through
    private func searchEvents(url: URL) {
        let search = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(Events.self, from: data)
                self.events = searchResponse
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error thrown while searching data from SeatGeek API: \(error)")
            }
        }
        
        search.resume()
    }
    
    // MARK: - Search Bar Configuration
    
    func searchBar(_ searchBar: UISearchBar, textDidChange search: String) {
        if (favoritedEvents.count > 0 && searchBar.text == "" && latitude != "" && longitude != "") {
            getRecommendations()
        } else {
            searchEvents(url: createSearchURL(search: search))
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    // MARK: - Table View Configuration
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked event: \(events.events[indexPath.row].short_title)")
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "GoToEventDetail", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        
        if (events.events.count >= indexPath.row + 1) {
            cell.setupEventTableViewCell(event: events.events[indexPath.row], favoritedEventIDs: favoritedEvents)
        }

        return cell
    }
    
    // MARK: - Location Setup
    
    /// Updates coordinates each time user's location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else { return }
        
        latitude = String(first.coordinate.latitude)
        longitude = String(first.coordinate.longitude)
        print("Collected latitude/longitude for recommended events: \(latitude), \(longitude)")
        
        if (favoritedEvents.count > 0 && searchBar.text == "" && latitude != "" && longitude != "") {
            getRecommendations()
        }
    }
    
    // MARK: - Segue Setup
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToEventDetail"
        {
            if let vc = segue.destination as? DetailViewController
            {
                vc.selectedEvent = events.events[selectedIndex]
            }
        }
    }
    
    // MARK: - Emergency Database Method
    
    /// Emergency method to clear database
    private func deleteAll() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritedEvent")
        fetchRequest.includesPropertyValues = false

        do {
            let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]

            for item in items {
                managedContext.delete(item)
            }
            
            try managedContext.save()
        } catch let error {
            print("Error while wiping database: \(error)")
        }
    }
}
