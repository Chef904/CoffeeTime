//
//  CoffeeDetailView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct CoffeeDetailView: View {
    @State var entry: CoffeeEntry
    @ObservedObject var dataManager: CoffeeDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing = false
    @State private var newTastingNote = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    if isEditing {
                        TextField("Coffee Name", text: $entry.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    } else {
                        Text(entry.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Text(entry.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Rating Overview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Overall Rating")
                        .font(.headline)
                    
                    HStack {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: Double(index) < entry.rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                            }
                        }
                        
                        Spacer()
                        
                        Text(String(format: "%.1f/5.0", entry.rating))
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    if isEditing {
                        RatingSlider(title: "Rating", value: $entry.rating)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Basic Info Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Coffee Details")
                        .font(.headline)
                    
                    DetailRow(title: "Origin", value: entry.origin ?? "Unknown", isEditing: isEditing) {
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
                    }
                    
                    DetailRow(title: "Price", value: entry.price?.formatted(.currency(code: "USD")) ?? "Not specified", isEditing: isEditing) {
                        TextField("Price", value: $entry.price, format: .currency(code: "USD"))
                    }
                    
                    DetailRow(title: "Roast Level", value: entry.roastLevel.rawValue, isEditing: isEditing) {
                        Picker("Roast Level", selection: $entry.roastLevel) {
                            ForEach(RoastLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Preparation Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preparation")
                        .font(.headline)
                    
                    DetailRow(title: "Grinder", value: entry.grinder.isEmpty ? "Not specified" : entry.grinder, isEditing: isEditing) {
                        TextField("Grinder", text: $entry.grinder)
                    }
                    
                    DetailRow(title: "Grind Level", value: entry.grindLevel.rawValue, isEditing: isEditing) {
                        Picker("Grind Level", selection: $entry.grindLevel) {
                            ForEach(GrindLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                    }
                    
                    DetailRow(title: "Brew Method", value: entry.brewMethod.rawValue, isEditing: isEditing) {
                        Picker("Brew Method", selection: $entry.brewMethod) {
                            ForEach(BrewMethod.allCases, id: \.self) { method in
                                Text(method.rawValue).tag(method)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Tasting Profile
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tasting Profile")
                        .font(.headline)
                    
                    if isEditing {
                        RatingSlider(title: "Aroma", value: $entry.aroma)
                        RatingSlider(title: "Acidity", value: $entry.acidity)
                        RatingSlider(title: "Body", value: $entry.body)
                        RatingSlider(title: "Flavor", value: $entry.flavor)
                        RatingSlider(title: "Aftertaste", value: $entry.aftertaste)
                    } else {
                        TastingProfileRow(title: "Aroma", value: entry.aroma)
                        TastingProfileRow(title: "Acidity", value: entry.acidity)
                        TastingProfileRow(title: "Body", value: entry.body)
                        TastingProfileRow(title: "Flavor", value: entry.flavor)
                        TastingProfileRow(title: "Aftertaste", value: entry.aftertaste)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Tasting Notes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Tasting Notes")
                        .font(.headline)
                    
                    if isEditing {
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
                    }
                    
                    if entry.tastingNotes.isEmpty {
                        Text("No tasting notes added")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(entry.tastingNotes.indices, id: \.self) { index in
                            HStack {
                                Text("• \(entry.tastingNotes[index])")
                                Spacer()
                                if isEditing {
                                    Button("Remove") {
                                        entry.tastingNotes.remove(at: index)
                                    }
                                    .foregroundColor(.red)
                                    .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Notes Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Overall Notes")
                        .font(.headline)
                    
                    if isEditing {
                        TextField("Overall notes and impressions", text: $entry.overallNotes, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                    } else {
                        if entry.overallNotes.isEmpty {
                            Text("No notes added")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            Text(entry.overallNotes)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .navigationTitle("Coffee Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        dataManager.updateEntry(entry)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}

struct DetailRow<EditView: View>: View {
    let title: String
    let value: String
    let isEditing: Bool
    let editView: () -> EditView
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            
            if isEditing {
                editView()
            } else {
                Text(value)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

struct TastingProfileRow: View {
    let title: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: Double(index) < value ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Text(String(format: "%.1f", value))
                .foregroundColor(.secondary)
        }
    }
}