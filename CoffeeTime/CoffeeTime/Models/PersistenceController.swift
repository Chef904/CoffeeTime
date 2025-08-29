//
//  PersistenceController.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 29.08.25.
//

import CoreData
import CloudKit

class PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Add sample data for previews
        let sampleCoffee = CoffeeEntity(context: viewContext)
        sampleCoffee.id = UUID()
        sampleCoffee.name = "Sample Coffee"
        sampleCoffee.origin = "Ethiopia"
        sampleCoffee.roastLevel = "medium"
        sampleCoffee.dateAdded = Date()
        sampleCoffee.coffeeDescription = "A sample coffee for preview"
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CoffeeDataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Configure for CloudKit
        container.persistentStoreDescriptions.forEach { storeDescription in
            // Enable CloudKit sync
            storeDescription.setOption(true as NSNumber, 
                                     forKey: NSPersistentHistoryTrackingKey)
            storeDescription.setOption(true as NSNumber, 
                                     forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data error: \(error), \(error.userInfo)")
                // Don't crash - app can still work locally
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}