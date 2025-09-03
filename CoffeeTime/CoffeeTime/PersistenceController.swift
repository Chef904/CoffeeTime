//
//  PersistenceController.swift
//  CoffeeTime
//
//  Centralizes SwiftData + CloudKit ModelContainer creation with robust fallbacks.
//

import Foundation
import SwiftData

struct PersistenceController {
    static let shared = PersistenceController()
    let modelContainer: ModelContainer
    
    init(inMemory: Bool = false) {
        // Fast path: in-memory for previews/tests
        if inMemory {
            do {
                let memConfig = ModelConfiguration(isStoredInMemoryOnly: true)
                modelContainer = try ModelContainer(
                    for: Coffee.self, BrewingSession.self, TastingNote.self,
                    configurations: memConfig
                )
                return
            } catch {
                fatalError("Failed to create in-memory ModelContainer: \(error)")
            }
        }
        
        // 1) Primary: CloudKit-backed container (versioned config)
        do {
            let cloudConfig = ModelConfiguration(
                "CoffeeTimeModelV2",
                cloudKitDatabase: .private("iCloud.johannesTou.CoffeeTime")
            )
            modelContainer = try ModelContainer(
                for: Coffee.self, BrewingSession.self, TastingNote.self,
                configurations: cloudConfig
            )
            print("CloudKit synchronization enabled")
            return
        } catch {
            print("CloudKit failed: \(error)")
        }
        
        // 2) Fallback: default local store with versioned name
        do {
            let localConfig = ModelConfiguration("CoffeeTimeLocalV2")
            modelContainer = try ModelContainer(
                for: Coffee.self, BrewingSession.self, TastingNote.self,
                configurations: localConfig
            )
            print("Using local storage (fallback)")
            return
        } catch {
            print("Local storage failed: \(error)")
        }
        
        // 3) Fresh local store with unique URL in Application Support
        let fileManager = FileManager.default
        let appSupportBase = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundlePath = (Bundle.main.bundleIdentifier ?? "CoffeeTime")
        let storeDir = appSupportBase.appendingPathComponent(bundlePath, isDirectory: true)
        try? fileManager.createDirectory(at: storeDir, withIntermediateDirectories: true)
        let freshURL = storeDir.appendingPathComponent("CoffeeTimeLocalFresh-\(UUID().uuidString).store")
        
        do {
            let freshConfig = ModelConfiguration("CoffeeTimeLocalFreshV2", url: freshURL)
            modelContainer = try ModelContainer(
                for: Coffee.self, BrewingSession.self, TastingNote.self,
                configurations: freshConfig
            )
            print("Created fresh storage at \(freshURL.path)")
            return
        } catch {
            print("Fresh local storage failed: \(error)")
        }
        
        // 4) Final fallback: in-memory so the app can still run
        do {
            let memConfig = ModelConfiguration(isStoredInMemoryOnly: true)
            modelContainer = try ModelContainer(
                for: Coffee.self, BrewingSession.self, TastingNote.self,
                configurations: memConfig
            )
            print("Using in-memory store as final fallback")
        } catch {
            fatalError("Failed to create any ModelContainer: \(error)")
        }
    }
}
