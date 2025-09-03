//
//  CoffeeDataManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import Foundation
import Combine
import SwiftData

@Observable
class CoffeeDataManager {
    static let shared = CoffeeDataManager()
    
    var coffees: [Coffee] = []
    private var modelContext: ModelContext?
    
    init() {
        // The model context will be set by the app when the container is available
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadCoffees()
    }
    
    // MARK: - SwiftData Methods
    
    private func loadCoffees() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<Coffee>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        
        do {
            coffees = try context.fetch(descriptor)
        } catch {
            print("Error loading coffees: \(error)")
            coffees = []
        }
    }
    
    // MARK: - Public Methods
    
    func addCoffee(_ coffee: Coffee) {
        guard let context = modelContext else { return }
        
        context.insert(coffee)
        saveContext()
        loadCoffees()
    }
    
    func addEntry(_ entry: CoffeeEntry) {
        // Convert CoffeeEntry to Coffee with BrewingSession
        let newCoffee = Coffee(
            name: entry.name,
            origin: entry.origin,
            roaster: nil,
            description: entry.overallNotes
        )
        
        newCoffee.price = entry.price
        newCoffee.roastLevel = entry.roastLevel
        newCoffee.dateAdded = entry.date
        
        // Create a brewing session from the entry data
        let brewingSession = BrewingSession(
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
        brewingSession.coffee = newCoffee
        
        if newCoffee.brewingSessions == nil { newCoffee.brewingSessions = [] }
        newCoffee.brewingSessions?.append(brewingSession)
        
        addCoffee(newCoffee)
    }
    
    func updateCoffee(_ coffee: Coffee) {
        saveContext()
        loadCoffees()
    }
    
    func deleteCoffee(_ coffee: Coffee) {
        guard let context = modelContext else { return }
        
        context.delete(coffee)
        saveContext()
        loadCoffees()
    }
    
    func addBrewingSession(_ session: BrewingSession, to coffee: Coffee) {
        guard let context = modelContext else { return }
        
        session.coffee = coffee
        if coffee.brewingSessions == nil { coffee.brewingSessions = [] }
        coffee.brewingSessions?.append(session)
        context.insert(session)
        saveContext()
        loadCoffees()
    }
    
    func updateBrewingSession(_ session: BrewingSession) {
        saveContext()
        loadCoffees()
    }
    
    func deleteBrewingSession(_ session: BrewingSession, from coffee: Coffee) {
        guard let context = modelContext else { return }
        
        if var sessions = coffee.brewingSessions, let idx = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions.remove(at: idx)
            coffee.brewingSessions = sessions
        }
        context.delete(session)
        saveContext()
        loadCoffees()
    }
    
    private func saveContext() {
        guard let context = modelContext else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
