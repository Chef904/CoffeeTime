//
//  CoffeeEntry.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import Foundation

struct CoffeeEntry: Identifiable, Codable {
    let id = UUID()
    var name: String
    var date: Date
    var rating: Double // 1-5 stars
    var price: Double?
    var grindLevel: GrindLevel
    var grinder: String
    var brewMethod: BrewMethod
    var origin: String?
    var roastLevel: RoastLevel
    var tastingNotes: [String]
    var overallNotes: String
    var aroma: Double // 1-5 rating
    var acidity: Double // 1-5 rating
    var body: Double // 1-5 rating
    var flavor: Double // 1-5 rating
    var aftertaste: Double // 1-5 rating
    
    init(name: String = "", grinder: String = "", origin: String? = nil, overallNotes: String = "") {
        self.name = name
        self.date = Date()
        self.rating = 3.0
        self.price = nil
        self.grindLevel = .medium
        self.grinder = grinder
        self.brewMethod = .drip
        self.origin = origin
        self.roastLevel = .medium
        self.tastingNotes = []
        self.overallNotes = overallNotes
        self.aroma = 3.0
        self.acidity = 3.0
        self.body = 3.0
        self.flavor = 3.0
        self.aftertaste = 3.0
    }
}

enum GrindLevel: String, CaseIterable, Codable {
    case extraCoarse = "Extra Coarse"
    case coarse = "Coarse"
    case mediumCoarse = "Medium Coarse"
    case medium = "Medium"
    case mediumFine = "Medium Fine"
    case fine = "Fine"
    case extraFine = "Extra Fine"
}

enum BrewMethod: String, CaseIterable, Codable {
    case drip = "Drip Coffee"
    case espresso = "Espresso"
    case frenchPress = "French Press"
    case pourOver = "Pour Over"
    case aeropress = "AeroPress"
    case chemex = "Chemex"
    case v60 = "V60"
    case coldBrew = "Cold Brew"
    case moka = "Moka Pot"
    case turkish = "Turkish"
}

enum RoastLevel: String, CaseIterable, Codable {
    case light = "Light"
    case mediumLight = "Medium Light"
    case medium = "Medium"
    case mediumDark = "Medium Dark"
    case dark = "Dark"
}