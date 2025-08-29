//
//  CoffeeEntity+CoreDataClass.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 29.08.25.
//

import CoreData
import Foundation

@objc(CoffeeEntity)
public class CoffeeEntity: NSManagedObject {
    
}

extension CoffeeEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoffeeEntity> {
        return NSFetchRequest<CoffeeEntity>(entityName: "CoffeeEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var origin: String?
    @NSManaged public var price: Double
    @NSManaged public var roastLevel: String?
    @NSManaged public var roaster: String?
    @NSManaged public var coffeeDescription: String?
    @NSManaged public var imageName: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var brewingSessions: NSSet?
}

// MARK: Generated accessors for brewingSessions
extension CoffeeEntity {
    @objc(addBrewingSessionsObject:)
    @NSManaged public func addToBrewingSessions(_ value: BrewingSessionEntity)

    @objc(removeBrewingSessionsObject:)
    @NSManaged public func removeFromBrewingSessions(_ value: BrewingSessionEntity)

    @objc(addBrewingSessions:)
    @NSManaged public func addToBrewingSessions(_ values: NSSet)

    @objc(removeBrewingSessions:)
    @NSManaged public func removeFromBrewingSessions(_ values: NSSet)
}

extension CoffeeEntity: Identifiable {
    var averageRating: Double {
        guard let sessions = brewingSessions?.allObjects as? [BrewingSessionEntity],
              !sessions.isEmpty else { return 0.0 }
        return sessions.map { $0.rating }.reduce(0, +) / Double(sessions.count)
    }
    
    var brewingSessionsArray: [BrewingSessionEntity] {
        let set = brewingSessions as? Set<BrewingSessionEntity> ?? []
        return set.sorted { $0.date ?? Date() > $1.date ?? Date() }
    }
    
    // Convert to Coffee struct for UI
    var coffee: Coffee {
        var result = Coffee(
            name: name ?? "",
            origin: origin,
            roaster: roaster,
            description: coffeeDescription ?? ""
        )
        result.price = price > 0 ? price : nil
        result.roastLevel = RoastLevel(rawValue: roastLevel ?? "medium") ?? .medium
        result.imageName = imageName
        result.dateAdded = dateAdded ?? Date()
        result.brewingSessions = brewingSessionsArray.map { $0.brewingSession }
        return result
    }
    
    // Update from Coffee struct
    func update(from coffee: Coffee) {
        self.name = coffee.name
        self.origin = coffee.origin
        self.price = coffee.price ?? 0
        self.roastLevel = coffee.roastLevel.rawValue
        self.roaster = coffee.roaster
        self.coffeeDescription = coffee.description
        self.imageName = coffee.imageName
        self.dateAdded = coffee.dateAdded
    }
}