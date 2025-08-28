//
//  BrewingSessionDetailView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct BrewingSessionDetailView: View {
    @State var session: BrewingSession
    let coffee: Coffee
    @ObservedObject var dataManager: CoffeeDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing = false
    @State private var newTastingNote = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Durchlauf vom \(session.date, style: .date)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Kaffee: \(coffee.name)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Rating Overview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bewertung")
                        .font(.headline)
                    
                    HStack {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: Double(index) < session.rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                            }
                        }
                        
                        Spacer()
                        
                        Text(String(format: "%.1f/5.0", session.rating))
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    if isEditing {
                        RatingSlider(title: "Bewertung", value: $session.rating)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Preparation Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Zubereitung")
                        .font(.headline)
                    
                    SessionDetailRow(title: "Mühle", value: session.grinder.isEmpty ? "Nicht angegeben" : session.grinder, isEditing: isEditing) {
                        TextField("Mühle", text: $session.grinder)
                    }
                    
                    SessionDetailRow(title: "Mahlgrad", value: session.grindLevel.rawValue, isEditing: isEditing) {
                        Picker("Mahlgrad", selection: $session.grindLevel) {
                            ForEach(GrindLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                    }
                    
                    SessionDetailRow(title: "Methode", value: session.brewMethod.rawValue, isEditing: isEditing) {
                        Picker("Zubereitungsart", selection: $session.brewMethod) {
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
                
                // Parameters Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Parameter")
                        .font(.headline)
                    
                    SessionDetailRow(
                        title: "Wassertemperatur",
                        value: session.waterTemperature.map { "\($0, specifier: "%.0f")°C" } ?? "Nicht angegeben",
                        isEditing: isEditing
                    ) {
                        HStack {
                            TextField("°C", value: $session.waterTemperature, format: .number)
                            Text("°C")
                        }
                    }
                    
                    SessionDetailRow(
                        title: "Brühzeit",
                        value: session.brewTime.map { "\($0, specifier: "%.0f") Sekunden" } ?? "Nicht angegeben",
                        isEditing: isEditing
                    ) {
                        HStack {
                            TextField("Sekunden", value: Binding(
                                get: { session.brewTime ?? 0 },
                                set: { session.brewTime = $0 > 0 ? $0 : nil }
                            ), format: .number)
                            Text("sec")
                        }
                    }
                    
                    SessionDetailRow(
                        title: "Kaffeemenge",
                        value: session.coffeeAmount.map { "\($0, specifier: "%.1f")g" } ?? "Nicht angegeben",
                        isEditing: isEditing
                    ) {
                        HStack {
                            TextField("Gramm", value: $session.coffeeAmount, format: .number)
                            Text("g")
                        }
                    }
                    
                    SessionDetailRow(
                        title: "Wassermenge",
                        value: session.waterAmount.map { "\($0, specifier: "%.0f")ml" } ?? "Nicht angegeben",
                        isEditing: isEditing
                    ) {
                        HStack {
                            TextField("ml", value: $session.waterAmount, format: .number)
                            Text("ml")
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Tasting Profile
                VStack(alignment: .leading, spacing: 12) {
                    Text("Geschmacksprofil")
                        .font(.headline)
                    
                    if isEditing {
                        RatingSlider(title: "Aroma", value: $session.aroma)
                        RatingSlider(title: "Säure", value: $session.acidity)
                        RatingSlider(title: "Körper", value: $session.body)
                        RatingSlider(title: "Geschmack", value: $session.flavor)
                        RatingSlider(title: "Nachgeschmack", value: $session.aftertaste)
                    } else {
                        TastingProfileRow(title: "Aroma", value: session.aroma)
                        TastingProfileRow(title: "Säure", value: session.acidity)
                        TastingProfileRow(title: "Körper", value: session.body)
                        TastingProfileRow(title: "Geschmack", value: session.flavor)
                        TastingProfileRow(title: "Nachgeschmack", value: session.aftertaste)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Tasting Notes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Geschmacksnotizen")
                        .font(.headline)
                    
                    if isEditing {
                        HStack {
                            TextField("Geschmacksnotiz hinzufügen", text: $newTastingNote)
                            Button("Hinzufügen") {
                                if !newTastingNote.isEmpty {
                                    session.tastingNotes.append(newTastingNote)
                                    newTastingNote = ""
                                }
                            }
                            .disabled(newTastingNote.isEmpty)
                        }
                    }
                    
                    if session.tastingNotes.isEmpty {
                        Text("Keine Geschmacksnotizen hinzugefügt")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(session.tastingNotes.indices, id: \.self) { index in
                            HStack {
                                Text("• \(session.tastingNotes[index])")
                                Spacer()
                                if isEditing {
                                    Button("Entfernen") {
                                        session.tastingNotes.remove(at: index)
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
                    Text("Notizen")
                        .font(.headline)
                    
                    if isEditing {
                        TextField("Notizen zu diesem Durchlauf", text: $session.sessionNotes, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                    } else {
                        if session.sessionNotes.isEmpty {
                            Text("Keine Notizen hinzugefügt")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            Text(session.sessionNotes)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .navigationTitle("Durchlauf Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Speichern" : "Bearbeiten") {
                    if isEditing {
                        dataManager.updateBrewingSession(session, in: coffee)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}

struct SessionDetailRow<EditView: View>: View {
    let title: String
    let value: String
    let isEditing: Bool
    let editView: () -> EditView
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .frame(width: 120, alignment: .leading)
            
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
                .frame(width: 120, alignment: .leading)
            
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