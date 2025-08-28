//
//  CoffeeDataManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import Foundation

class CoffeeDataManager: ObservableObject {
    @Published var coffees: [Coffee] = []
    
    private let saveKey = "Coffees"
    
    init() {
        loadCoffees()
    }
    
    func addCoffee(_ coffee: Coffee) {
        coffees.append(coffee)
        saveCoffees()
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
    
    func updateBrewingSession(_ session: BrewingSession, in coffee: Coffee) {
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
    
    private func saveCoffees() {
        if let encoded = try? JSONEncoder().encode(coffees) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadCoffees() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Coffee].self, from: data) {
            coffees = decoded
        }
    }
}
