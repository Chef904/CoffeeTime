//
//  CoffeeDataManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import Foundation
import CoreData
import Combine

class CoffeeDataManager: ObservableObject {
    static let shared = CoffeeDataManager()
    
    private let persistenceController = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var coffees: [Coffee] = []
    @Published var coffeeEntities: [CoffeeEntity] = []
    
    init() {
        fetchCoffees()
        
        // Listen for Core Data changes (including CloudKit sync)
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchCoffees()
            }
            .store(in: &cancellables)
    }
    
    func fetchCoffees() {
        let request: NSFetchRequest<CoffeeEntity> = CoffeeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CoffeeEntity.dateAdded, ascending: false)]
        
        do {
            coffeeEntities = try persistenceController.container.viewContext.fetch(request)
            coffees = coffeeEntities.map { $0.coffee }
        } catch {
            print("Error fetching coffees: \(error)")
        }
    }
    
    func addCoffee(_ coffee: Coffee) {
        let context = persistenceController.container.viewContext
        let coffeeEntity = CoffeeEntity(context: context)
        
        coffeeEntity.id = coffee.id
        coffeeEntity.update(from: coffee)
        
        saveContext()
    }
    
    func updateCoffee(_ coffeeEntity: CoffeeEntity, with coffee: Coffee) {
        coffeeEntity.update(from: coffee)
        saveContext()
    }
    
    // Convenience method for views that work with Coffee structs
    func updateCoffee(_ coffee: Coffee) {
        guard let coffeeEntity = coffeeEntities.first(where: { $0.id == coffee.id }) else { return }
        coffeeEntity.update(from: coffee)
        saveContext()
    }
    
    func deleteCoffee(_ coffee: Coffee) {
        guard let coffeeEntity = coffeeEntities.first(where: { $0.id == coffee.id }) else { return }
        let context = persistenceController.container.viewContext
        context.delete(coffeeEntity)
        saveContext()
    }
    
    func addBrewingSession(_ session: BrewingSession, to coffee: Coffee) {
        guard let coffeeEntity = coffeeEntities.first(where: { $0.id == coffee.id }) else { return }
        
        let context = persistenceController.container.viewContext
        let sessionEntity = BrewingSessionEntity(context: context)
        
        sessionEntity.id = session.id
        sessionEntity.update(from: session)
        sessionEntity.coffee = coffeeEntity
        
        saveContext()
    }
    
    func updateBrewingSession(_ sessionEntity: BrewingSessionEntity, with session: BrewingSession) {
        sessionEntity.update(from: session)
        saveContext()
    }
    
    // Convenience method for views that work with BrewingSession structs
    func updateBrewingSession(_ session: BrewingSession, in coffee: Coffee) {
        guard let coffeeEntity = coffeeEntities.first(where: { $0.id == coffee.id }),
              let sessionEntity = coffeeEntity.brewingSessionsArray.first(where: { $0.id == session.id }) else { return }
        
        sessionEntity.update(from: session)
        saveContext()
    }
    
    func deleteBrewingSession(_ session: BrewingSession, from coffee: Coffee) {
        guard let coffeeEntity = coffeeEntities.first(where: { $0.id == coffee.id }),
              let sessionEntity = coffeeEntity.brewingSessionsArray.first(where: { $0.id == session.id }) else { return }
        
        let context = persistenceController.container.viewContext
        context.delete(sessionEntity)
        saveContext()
    }
    
    private func saveContext() {
        let context = persistenceController.container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                // CloudKit will automatically sync this change
            } catch {
                print("Error saving context: \(error)")
                // App continues working locally even if sync fails
            }
        }
    }
}
