//
//  ThemeManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 29.08.25.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case system = "System"
    case light = "Hell"
    case dark = "Dunkel"
    
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
    
    var iconName: String {
        switch self {
        case .system:
            return "gear"
        case .light:
            return "sun.max"
        case .dark:
            return "moon"
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "selectedTheme"
    
    init() {
        let savedTheme = userDefaults.string(forKey: themeKey) ?? AppTheme.system.rawValue
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .system
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        userDefaults.set(theme.rawValue, forKey: themeKey)
    }
}