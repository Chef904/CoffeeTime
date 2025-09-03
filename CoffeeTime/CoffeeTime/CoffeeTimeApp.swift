//
//  CoffeeTimeApp.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI
import SwiftData

@main
struct CoffeeTimeApp: App {
    @StateObject private var settingsManager = SettingsManager.shared
    
    let modelContainer: ModelContainer
    
    init() {
        // First try local storage to ensure basic functionality works
        do {
            modelContainer = try ModelContainer(for: Coffee.self, BrewingSession.self, TastingNote.self)
            print("Using local storage - CloudKit can be enabled later")
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        
        // TODO: Enable CloudKit once capabilities are configured
        // modelContainer = try ModelContainer(
        //     for: Coffee.self, BrewingSession.self, TastingNote.self,
        //     configurations: ModelConfiguration(
        //         "CoffeeTimeModel",
        //         cloudKitDatabase: .private("iCloud.com.johannestourbeslis.CoffeeTime")
        //     )
        // )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settingsManager.appearanceMode.colorScheme)
                .modelContainer(modelContainer)
                .onAppear {
                    // Set the model context in the data manager
                    CoffeeDataManager.shared.setModelContext(modelContainer.mainContext)
                }
        }
    }
}
