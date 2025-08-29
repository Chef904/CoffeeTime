//
//  SettingsView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 29.08.25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var themeManager: ThemeManager
    @StateObject private var cloudKitManager = CloudKitManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Erscheinungsbild") {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        HStack {
                            Image(systemName: theme.iconName)
                                .foregroundColor(.accentColor)
                                .frame(width: 24)
                            
                            Text(theme.rawValue)
                            
                            Spacer()
                            
                            if themeManager.currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            themeManager.setTheme(theme)
                        }
                    }
                }
                
                Section("Datensynchronisation") {
                    HStack {
                        Image(systemName: cloudKitManager.isCloudKitAvailable ? "icloud.fill" : "icloud.slash")
                            .foregroundColor(cloudKitManager.isCloudKitAvailable ? .green : .orange)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading) {
                            Text(cloudKitManager.syncStatus)
                                .font(.headline)
                            
                            if cloudKitManager.isCloudKitAvailable {
                                Text("Ihre Kaffeedaten werden automatisch zwischen allen Geräten synchronisiert.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Melden Sie sich in iCloud an, um Daten zwischen Geräten zu synchronisieren.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Button("Status aktualisieren") {
                        cloudKitManager.checkCloudKitStatus()
                    }
                    .foregroundColor(.accentColor)
                }
                
                Section("Über die App") {
                    HStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundColor(.brown)
                            .frame(width: 24)
                        VStack(alignment: .leading) {
                            Text("Kaffee Journal")
                                .font(.headline)
                            Text("Version 1.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(themeManager: ThemeManager())
}
