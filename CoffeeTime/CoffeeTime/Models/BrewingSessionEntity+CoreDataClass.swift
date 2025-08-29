//
//  BrewingSessionEntity+CoreDataClass.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 29.08.25.
//

import CoreData
import Foundation

@objc(BrewingSessionEntity)
public class BrewingSessionEntity: NSManagedObject {
    
}

extension BrewingSessionEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BrewingSessionEntity> {
        return NSFetchRequest<BrewingSessionEntity>(entityName: "BrewingSessionEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var rating: Double
    @NSManaged public var grindLevel: String?
    @NSManaged public var grinder: String?
    @NSManaged public var brewMethod: String?
    @NSManaged public var waterTemperature: Double
    @NSManaged public var brewTime: Double
    @NSManaged public var coffeeAmount: Double
    @NSManaged public var waterAmount: Double
    @NSManaged public var tastingNotesData: Data?
    @NSManaged public var sessionNotes: String?
    @NSManaged public var aroma: Double
    @NSManaged public var acidity: Double
    @NSManaged public var body: Double
    @NSManaged public var flavor: Double
    @NSManaged public var aftertaste: Double
    @NSManaged public var coffee: CoffeeEntity?
}

extension BrewingSessionEntity: Identifiable {
    var tastingNotes: [String] {
        get {
            guard let data = tastingNotesData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            tastingNotesData = try? JSONEncoder().encode(newValue)
        }
    }
    
    // Convert to BrewingSession struct for UI
    var brewingSession: BrewingSession {
        var result = BrewingSession(
            grinder: grinder ?? "",
            sessionNotes: sessionNotes ?? ""
        )
        result.date = date ?? Date()
        result.rating = rating
        result.grindLevel = GrindLevel(rawValue: grindLevel ?? "medium") ?? .medium
        result.brewMethod = BrewMethod(rawValue: brewMethod ?? "drip") ?? .drip
        result.waterTemperature = waterTemperature > 0 ? waterTemperature : nil
        result.brewTime = brewTime > 0 ? brewTime : nil
        result.coffeeAmount = coffeeAmount > 0 ? coffeeAmount : nil
        result.waterAmount = waterAmount > 0 ? waterAmount : nil
        result.tastingNotes = tastingNotes
        result.aroma = aroma
        result.acidity = acidity
        result.body = body
        result.flavor = flavor
        result.aftertaste = aftertaste
        return result
    }
    
    // Update from BrewingSession struct
    func update(from session: BrewingSession) {
        self.date = session.date
        self.rating = session.rating
        self.grindLevel = session.grindLevel.rawValue
        self.grinder = session.grinder
        self.brewMethod = session.brewMethod.rawValue
        self.waterTemperature = session.waterTemperature ?? 0
        self.brewTime = session.brewTime ?? 0
        self.coffeeAmount = session.coffeeAmount ?? 0
        self.waterAmount = session.waterAmount ?? 0
        self.tastingNotes = session.tastingNotes
        self.sessionNotes = session.sessionNotes
        self.aroma = session.aroma
        self.acidity = session.acidity
        self.body = session.body
        self.flavor = session.flavor
        self.aftertaste = session.aftertaste
    }
}