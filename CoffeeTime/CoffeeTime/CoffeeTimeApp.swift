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
    
    // Use centralized container
    let modelContainer: ModelContainer = PersistenceController.shared.modelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settingsManager.appearanceMode.colorScheme)
                .modelContainer(modelContainer)
                .onAppear {
                    CoffeeDataManager.shared.setModelContext(modelContainer.mainContext)
                }
        }
    }
}
