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
