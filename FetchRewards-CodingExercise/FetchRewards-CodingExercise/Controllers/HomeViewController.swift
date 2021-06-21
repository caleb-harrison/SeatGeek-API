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
        
        deleteAll()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getEvents()
        getFavorites()
    }
    
    // MARK: - SeatGeek API Configuration
    
    // REDO
    func getEvents() {
        guard let url = URL(string: "https://api.seatgeek.com/2/events?client_id=\(clientID)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let eventsData = try decoder.decode(Events.self, from: data)
                self.events = eventsData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error thrown while fetching data from SeatGeek API: \(error)")
            }
        }
        
        task.resume()
    }
    
    // REDO
    func getFavorites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedEvent")
        
        do {
            favoritedEvents = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error thrown while fetching favorited events: \(error), \(error.userInfo)")
        }
    }
    
    // REDO
    // Function to build an API request URL from the Search Bar Text
    func createSearchURL(searchText: String) -> URL {
        var searchQuery = "https://api.seatgeek.com/2/events?client_id=\(clientID)&q="
        searchQuery.append(searchText.replacingOccurrences(of: " ", with: "+").lowercased())
        
        return URL(string: searchQuery)!
    }
    
    // REDO
    // Function to search the SeatGeek API
    func searchEvents(url: URL) {
        let search = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let eventsData = try decoder.decode(Events.self, from: data)
                self.events = eventsData
                
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchEvents(url: createSearchURL(searchText: searchText))
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
        let count = events.events.count
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        
        if (events.events.count >= indexPath.row) {
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
    
    func deleteAll() {
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
