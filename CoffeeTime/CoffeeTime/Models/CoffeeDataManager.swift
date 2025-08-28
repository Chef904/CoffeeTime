//
//  CoffeeDataManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import Foundation

class CoffeeDataManager: ObservableObject {
    @Published var coffeeEntries: [CoffeeEntry] = []
    
    private let saveKey = "CoffeeEntries"
    
    init() {
        loadEntries()
    }
    
    func addEntry(_ entry: CoffeeEntry) {
        coffeeEntries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: CoffeeEntry) {
        if let index = coffeeEntries.firstIndex(where: { $0.id == entry.id }) {
            coffeeEntries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: CoffeeEntry) {
        coffeeEntries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(coffeeEntries) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([CoffeeEntry].self, from: data) {
            coffeeEntries = decoded
        }
    }
}