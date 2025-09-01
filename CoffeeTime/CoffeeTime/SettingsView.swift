//
//  SettingsView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 01.09.25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsManager = SettingsManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Darstellung") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("App-Design")
                            .font(.headline)
                        
                        Picker("Darstellung", selection: $settingsManager.appearanceMode) {
                            ForEach(AppearanceMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Text("Wählen Sie zwischen hellem, dunklem Modus oder folgen Sie den Systemeinstellungen.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Über die App") {
                    HStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundColor(.brown)
                        VStack(alignment: .leading) {
                            Text("CoffeeTime")
                                .font(.headline)
                            Text("Ihr persönliches Kaffee-Journal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("1.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
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
    SettingsView()
}
