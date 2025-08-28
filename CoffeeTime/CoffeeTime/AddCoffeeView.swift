//
//  AddCoffeeView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct AddCoffeeView: View {
    @ObservedObject var dataManager: CoffeeDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var coffee = Coffee()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Grundinformationen") {
                    TextField("Kaffee Name", text: $coffee.name)
                    
                    TextField("Rösterei", text: Binding(
                        get: { coffee.roaster ?? "" },
                        set: { coffee.roaster = $0.isEmpty ? nil : $0 }
                    ))
                    
                    Picker("Herkunft", selection: $coffee.origin) {
                        Text("Unbekannt").tag(nil as String?)
                        Text("Äthiopien").tag("Äthiopien" as String?)
                        Text("Kolumbien").tag("Kolumbien" as String?)
                        Text("Brasilien").tag("Brasilien" as String?)
                        Text("Guatemala").tag("Guatemala" as String?)
                        Text("Kenia").tag("Kenia" as String?)
                        Text("Jamaika").tag("Jamaika" as String?)
                        Text("Jemen").tag("Jemen" as String?)
                        Text("Peru").tag("Peru" as String?)
                        Text("Costa Rica").tag("Costa Rica" as String?)
                        Text("Honduras").tag("Honduras" as String?)
                        Text("Nicaragua").tag("Nicaragua" as String?)
                        Text("Andere").tag("Andere" as String?)
                    }
                    
                    Picker("Röstgrad", selection: $coffee.roastLevel) {
                        ForEach(RoastLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }
                
                Section("Preis & Details") {
                    HStack {
                        Text("Preis")
                        Spacer()
                        TextField("0,00", value: $coffee.price, format: .currency(code: "EUR"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                    }
                    
                    TextField("Beschreibung", text: $coffee.description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
                
                Section {
                    Text("Sie können nach dem Erstellen der Kaffeesorte verschiedene Zubereitungsdurchläufe hinzufügen.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Neue Kaffeesorte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        dataManager.addCoffee(coffee)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(coffee.name.isEmpty)
                }
            }
        }
    }
}