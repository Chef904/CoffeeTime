//
//  AddCoffeeEntryView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct AddCoffeeEntryView: View {
    @Bindable var dataManager: CoffeeDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var entry = CoffeeEntry()
    @State private var newTastingNote = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("Coffee Name", text: $entry.name)
                    
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("0.00", value: $entry.price, format: .currency(code: "USD"))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                    }
                    
                    Picker("Origin", selection: $entry.origin) {
                        Text("Unknown").tag(nil as String?)
                        Text("Ethiopia").tag("Ethiopia" as String?)
                        Text("Colombia").tag("Colombia" as String?)
                        Text("Brazil").tag("Brazil" as String?)
                        Text("Guatemala").tag("Guatemala" as String?)
                        Text("Kenya").tag("Kenya" as String?)
                        Text("Jamaica").tag("Jamaica" as String?)
                        Text("Yemen").tag("Yemen" as String?)
                        Text("Peru").tag("Peru" as String?)
                        Text("Other").tag("Other" as String?)
                    }
                    
                    Picker("Roast Level", selection: $entry.roastLevel) {
                        ForEach(RoastLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }
                
                Section("Preparation") {
                    TextField("Grinder Used", text: $entry.grinder)
                    
                    Picker("Grind Level", selection: $entry.grindLevel) {
                        ForEach(GrindLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    Picker("Brew Method", selection: $entry.brewMethod) {
                        ForEach(BrewMethod.allCases, id: \.self) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                }
                
                Section("Tasting Profile") {
                    VStack(alignment: .leading, spacing: 12) {
                        RatingSlider(title: "Overall Rating", value: $entry.rating)
                        RatingSlider(title: "Aroma", value: $entry.aroma)
                        RatingSlider(title: "Acidity", value: $entry.acidity)
                        RatingSlider(title: "Body", value: $entry.body)
                        RatingSlider(title: "Flavor", value: $entry.flavor)
                        RatingSlider(title: "Aftertaste", value: $entry.aftertaste)
                    }
                }
                
                Section("Tasting Notes") {
                    HStack {
                        TextField("Add tasting note", text: $newTastingNote)
                        Button("Add") {
                            if !newTastingNote.isEmpty {
                                entry.tastingNotes.append(newTastingNote)
                                newTastingNote = ""
                            }
                        }
                        .disabled(newTastingNote.isEmpty)
                    }
                    
                    ForEach(entry.tastingNotes.indices, id: \.self) { index in
                        HStack {
                            Text(entry.tastingNotes[index])
                            Spacer()
                            Button("Remove") {
                                entry.tastingNotes.remove(at: index)
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Overall notes and impressions", text: $entry.overallNotes, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                }
            }
            .navigationTitle("New Coffee Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dataManager.addEntry(entry)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(entry.name.isEmpty)
                }
            }
        }
    }
}

struct RatingSlider: View {
    let title: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text(String(format: "%.1f", value))
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("1")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Slider(value: $value, in: 1...5, step: 0.1)
                
                Text("5")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
