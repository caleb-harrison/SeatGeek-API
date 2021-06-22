//
//  ViewController.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/18/21.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var events = Events(events: [])
    private var favoritedEvents: [NSManagedObject] = []
    private var selectedIndex: Int!
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private let clientID = "MjIyODc5MzZ8MTYyNDA4ODc5NS4wNDIyNDMy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup searchbar
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensures back button maintains same events as search
        searchEvents(url: createSearchURL(search: searchBar.text ?? ""))
        getFavorites()
    }
    
    // MARK: - SeatGeek API Configuration
    
    private func getEvents() {
        guard let url = URL(string: "https://api.seatgeek.com/2/events?client_id=\(clientID)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let eventsResponse = try decoder.decode(Events.self, from: data)
                self.events = eventsResponse
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error thrown while fetching data from SeatGeek API: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func getFavorites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedEvent")
        
        do {
            favoritedEvents = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error thrown while fetching favorited events: \(error), \(error.userInfo)")
        }
    }
    
    private func createSearchURL(search: String) -> URL {
        let query = "https://api.seatgeek.com/2/events?client_id=\(clientID)&q=\(search.replacingOccurrences(of: " ", with: "+").lowercased())"
        return URL(string: query)!
    }
    
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
        searchEvents(url: createSearchURL(search: search))
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
    
    // Emergency method to clear database
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
