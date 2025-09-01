//
//  Coffee.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import Foundation
import SwiftData

@Model
class Coffee {
    @Attribute(.unique) var id: UUID
    var name: String
    var origin: String?
    var price: Double?
    var roastLevel: RoastLevel
    var roaster: String?
    var coffeeDescription: String
    var imageName: String?
    var dateAdded: Date
    
    @Relationship(deleteRule: .cascade, inverse: \BrewingSession.coffee)
    var brewingSessions: [BrewingSession] = []
    
    var averageRating: Double {
        guard !brewingSessions.isEmpty else { return 0.0 }
        return brewingSessions.map { $0.rating }.reduce(0, +) / Double(brewingSessions.count)
    }
    
    init(name: String = "", origin: String? = nil, roaster: String? = nil, description: String = "") {
        self.id = UUID()
        self.name = name
        self.origin = origin
        self.price = nil
        self.roastLevel = .medium
        self.roaster = roaster
        self.coffeeDescription = description
        self.imageName = nil
        self.dateAdded = Date()
    }
}

@Model
class TastingNote {
    var note: String
    var brewingSession: BrewingSession?
    
    init(note: String) {
        self.note = note
    }
}

@Model
class BrewingSession {
    @Attribute(.unique) var id: UUID
    var date: Date
    var rating: Double // 1-5 stars
    var grindLevel: GrindLevel
    var grinder: String
    var brewMethod: BrewMethod
    var waterTemperature: Double? // in Celsius
    var brewTime: TimeInterval? // in seconds
    var coffeeAmount: Double? // in grams
    var waterAmount: Double? // in ml
    var sessionNotes: String
    var aroma: Double // 1-5 rating
    var acidity: Double // 1-5 rating
    var body: Double // 1-5 rating
    var flavor: Double // 1-5 rating
    var aftertaste: Double // 1-5 rating
    
    var coffee: Coffee?
    @Relationship(deleteRule: .cascade, inverse: \TastingNote.brewingSession)
    var tastingNoteEntities: [TastingNote] = []
    
    // Computed property to maintain compatibility with existing code
    var tastingNotes: [String] {
        get {
            return tastingNoteEntities.map { $0.note }
        }
        set {
            // Remove existing notes
            tastingNoteEntities.removeAll()
            // Add new notes
            tastingNoteEntities = newValue.map { TastingNote(note: $0) }
        }
    }
    
    init(grinder: String = "", sessionNotes: String = "") {
        self.id = UUID()
        self.date = Date()
        self.rating = 3.0
        self.grindLevel = .medium
        self.grinder = grinder
        self.brewMethod = .drip
        self.waterTemperature = nil
        self.brewTime = nil
        self.coffeeAmount = nil
        self.waterAmount = nil
        self.sessionNotes = sessionNotes
        self.aroma = 3.0
        self.acidity = 3.0
        self.body = 3.0
        self.flavor = 3.0
        self.aftertaste = 3.0
    }
}

enum GrindLevel: String, CaseIterable, Codable {
    case extraCoarse = "Extra Grob"
    case coarse = "Grob"
    case mediumCoarse = "Mittel-Grob"
    case medium = "Mittel"
    case mediumFine = "Mittel-Fein"
    case fine = "Fein"
    case extraFine = "Extra Fein"
}

enum BrewMethod: String, CaseIterable, Codable {
    case drip = "Filterkaffee"
    case espresso = "Espresso"
    case frenchPress = "French Press"
    case pourOver = "Pour Over"
    case aeropress = "AeroPress"
    case chemex = "Chemex"
    case v60 = "V60"
    case coldBrew = "Cold Brew"
    case moka = "Moka"
    case turkish = "Türkischer Kaffee"
}

enum RoastLevel: String, CaseIterable, Codable {
    case light = "Hell"
    case mediumLight = "Mittel-Hell"
    case medium = "Mittel"
    case mediumDark = "Mittel-Dunkel"
    case dark = "Dunkel"
}
