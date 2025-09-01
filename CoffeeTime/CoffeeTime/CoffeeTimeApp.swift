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
        do {
            modelContainer = try ModelContainer(for: Coffee.self, BrewingSession.self, TastingNote.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
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
