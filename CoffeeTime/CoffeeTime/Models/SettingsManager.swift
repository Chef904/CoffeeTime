//
//  SettingsManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 01.09.25.
//

import SwiftUI
import Foundation

enum AppearanceMode: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var appearanceMode: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode")
        }
    }
    
    init() {
        let savedMode = UserDefaults.standard.string(forKey: "appearanceMode") ?? AppearanceMode.system.rawValue
        self.appearanceMode = AppearanceMode(rawValue: savedMode) ?? .system
    }
}