//
//  DetailViewController.swift
//  FetchRewards-CodingExercise
//
//  Created by Caleb Harrison on 6/18/21.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    var selectedEvent: Event!
    var favoritedEvent = false
    var favoritedEventIDs: [NSManagedObject] = []
    
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var eventImage: UIImageView!
    
    @IBOutlet var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFavoriteButton()
        setupLabels()
        setupImage()
        setupWordWrapping()
    }
    
    func setupFavoriteButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedEvent")
        
        do {
            favoritedEventIDs = try managedContext.fetch(fetchRequest)
            
            for event in favoritedEventIDs {
                if event.value(forKeyPath: "eventID") as? Int == selectedEvent.id {
                    favoritedEvent = true
                }
            }
        } catch let error as NSError {
            print("Error thrown while fetching favorited events: \(error), \(error.userInfo)")
        }
        
        if (favoritedEvent) {
            // Show red heart
            //favoriteButton.setImage(UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
            favoriteButton.tintColor = UIColor.systemRed
        } else {
            // Show empty heart
            //favoriteButton.setImage(UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
            favoriteButton.tintColor = UIColor.label
        }
    }
    
    func toggleFavorite() {
        favoritedEvent.toggle()
        
        if (favoritedEvent) {
            // Show red heart and save changes
            //favoriteButton.setImage(UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
            // save to database
            saveFavorite()
            favoriteButton.tintColor = UIColor.systemRed
        } else {
            // Show empty heart and delete favorite
            //favoriteButton.setImage(UIImage(named: "heart")?.withRenderingMode(.alwaysOriginal), for: .normal)
            deleteFavorite()
            favoriteButton.tintColor = UIColor.label
        }
    }
    
    @IBAction func favoriteButtonClicked() {
        toggleFavorite()
    }
    
    // Function to save an Event's ID to the Favorited Events in CoreData
    func saveFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoritedEvent", in: managedContext)!
        let favoritedEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        favoritedEvent.setValue(selectedEvent.id, forKeyPath: "eventID")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not favorite event: \(error), \(error.userInfo)")
        }
    }
    
    // Function to delete an Event's ID from the Favorited Events in CoreData
    func deleteFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for event in favoritedEventIDs {
            do {
                if event.value(forKeyPath: "eventID") as? Int == selectedEvent.id {
                    managedContext.delete(event)
                    try managedContext.save()
                }
            } catch let error {
                print("Could not delete/unfavorite event: \(error)")
            }
        }
    }
    
    func setupLabels() {
        eventLabel.text = selectedEvent.title
        dateTimeLabel.text = formatDateTime()
        locationLabel.text = formatLocation()
    }
    
    func setupImage() {
        eventImage.loadImage(from: selectedEvent.performers.first!.image!)
    }
    
    func formatDateTime() -> String {
        return selectedEvent.formatDateTime()
    }
    
    func formatLocation() -> String {
        return selectedEvent.formatLocation()
    }
    
    func setupWordWrapping() {
        eventLabel.numberOfLines = 0
        dateTimeLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
    }
    
    @IBAction func backButtonClicked() {
        self.dismiss(animated: true, completion: {
            // reload table view data and check if favorited
            // save to database?
        })
    }
    
}
