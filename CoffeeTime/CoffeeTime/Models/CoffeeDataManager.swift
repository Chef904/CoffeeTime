//
//  CoffeeDataManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import Foundation
import Combine

class CoffeeDataManager: ObservableObject {
    static let shared = CoffeeDataManager()
    
    @Published var coffees: [Coffee] = []
    
    private let coffeeFileURL: URL
    
    init() {
        // Set up file URL for storing coffee data
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        coffeeFileURL = documentsPath.appendingPathComponent("coffees.json")
        
        loadCoffees()
    }
    
    // MARK: - File-based Storage Methods
    
    private func loadCoffees() {
        do {
            let data = try Data(contentsOf: coffeeFileURL)
            coffees = try JSONDecoder().decode([Coffee].self, from: data)
        } catch {
            // If file doesn't exist or can't be read, start with empty array
            print("Could not load coffees: \(error)")
            coffees = []
        }
    }
    
    private func saveCoffees() {
        do {
            let data = try JSONEncoder().encode(coffees)
            try data.write(to: coffeeFileURL)
        } catch {
            print("Error saving coffees: \(error)")
        }
    }
    
    // MARK: - Public Methods
    
    func addCoffee(_ coffee: Coffee) {
        coffees.append(coffee)
        saveCoffees()
    }
    
    func addEntry(_ entry: CoffeeEntry) {
        // Convert CoffeeEntry to Coffee with BrewingSession
        var newCoffee = Coffee(
            name: entry.name,
            origin: entry.origin,
            roaster: nil,
            description: entry.overallNotes
        )
        
        newCoffee.price = entry.price
        newCoffee.roastLevel = entry.roastLevel
        newCoffee.dateAdded = entry.date
        
        // Create a brewing session from the entry data
        var brewingSession = BrewingSession(
            grinder: entry.grinder,
            sessionNotes: entry.overallNotes
        )
        brewingSession.date = entry.date
        brewingSession.rating = entry.rating
        brewingSession.grindLevel = entry.grindLevel
        brewingSession.brewMethod = entry.brewMethod
        brewingSession.tastingNotes = entry.tastingNotes
        brewingSession.aroma = entry.aroma
        brewingSession.acidity = entry.acidity
        brewingSession.body = entry.body
        brewingSession.flavor = entry.flavor
        brewingSession.aftertaste = entry.aftertaste
        
        newCoffee.brewingSessions = [brewingSession]
        
        addCoffee(newCoffee)
    }
    
    func updateCoffee(_ coffee: Coffee) {
        if let index = coffees.firstIndex(where: { $0.id == coffee.id }) {
            coffees[index] = coffee
            saveCoffees()
        }
    }
    
    func deleteCoffee(_ coffee: Coffee) {
        coffees.removeAll { $0.id == coffee.id }
        saveCoffees()
    }
    
    func addBrewingSession(_ session: BrewingSession, to coffee: Coffee) {
        if let index = coffees.firstIndex(where: { $0.id == coffee.id }) {
            coffees[index].brewingSessions.append(session)
            saveCoffees()
        }
    }
    
    func updateBrewingSessionData(_ session: BrewingSession, in coffee: Coffee) {
        if let coffeeIndex = coffees.firstIndex(where: { $0.id == coffee.id }),
           let sessionIndex = coffees[coffeeIndex].brewingSessions.firstIndex(where: { $0.id == session.id }) {
            coffees[coffeeIndex].brewingSessions[sessionIndex] = session
            saveCoffees()
        }
    }
    
    func deleteBrewingSession(_ session: BrewingSession, from coffee: Coffee) {
        if let coffeeIndex = coffees.firstIndex(where: { $0.id == coffee.id }) {
            coffees[coffeeIndex].brewingSessions.removeAll { $0.id == session.id }
            saveCoffees()
        }
    }
}