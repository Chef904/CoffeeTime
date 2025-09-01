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
    @Bindable var dataManager: CoffeeDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing = false
    @State private var newTastingNote = ""
    
    var body: some View {
        ScrollView {
            mainContent
        }
        .navigationTitle("Durchlauf Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Speichern" : "Bearbeiten") {
                    if isEditing {
                        dataManager.updateBrewingSession(session)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
    
    private var mainContent: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            headerSection
            ratingSection
            preparationSection
            parametersSection
            tastingProfileSection
            tastingNotesSection
            notesSection
        }
    }
    
    // Helper computed properties for bindings
    private var waterTemperatureBinding: Binding<Double> {
        Binding(
            get: { session.waterTemperature ?? 0 },
            set: { session.waterTemperature = $0 > 0 ? $0 : nil }
        )
    }
    
    private var brewTimeBinding: Binding<Double> {
        Binding(
            get: { session.brewTime ?? 0 },
            set: { session.brewTime = $0 > 0 ? $0 : nil }
        )
    }
    
    private var coffeeAmountBinding: Binding<Double> {
        Binding(
            get: { session.coffeeAmount ?? 0 },
            set: { session.coffeeAmount = $0 > 0 ? $0 : nil }
        )
    }
    
    private var waterAmountBinding: Binding<Double> {
        Binding(
            get: { session.waterAmount ?? 0 },
            set: { session.waterAmount = $0 > 0 ? $0 : nil }
        )
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Durchlauf vom \(session.date, style: .date)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Kaffee: \(coffee.name)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var ratingSection: some View {
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
    }
    
    private var preparationSection: some View {
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
    }
    
    private var parametersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Parameter")
                .font(.headline)
            
            let waterTempValue = session.waterTemperature != nil ? String(format: "%.0f°C", session.waterTemperature!) : "Nicht angegeben"
            SessionDetailRow(
                title: "Wassertemperatur",
                value: waterTempValue,
                isEditing: isEditing
            ) {
                HStack {
                    TextField("Temperatur", value: waterTemperatureBinding, format: .number)
                    Text("°C")
                }
            }
            
            let brewTimeValue = session.brewTime != nil ? String(format: "%.0f Sekunden", session.brewTime!) : "Nicht angegeben"
            SessionDetailRow(
                title: "Brühzeit",
                value: brewTimeValue,
                isEditing: isEditing
            ) {
                HStack {
                    TextField("Zeit", value: brewTimeBinding, format: .number)
                    Text("Sekunden")
                }
            }
            
            let coffeeAmountValue = session.coffeeAmount != nil ? String(format: "%.1fg", session.coffeeAmount!) : "Nicht angegeben"
            SessionDetailRow(
                title: "Kaffeemenge",
                value: coffeeAmountValue,
                isEditing: isEditing
            ) {
                HStack {
                    TextField("Menge", value: coffeeAmountBinding, format: .number)
                    Text("g")
                }
            }
            
            let waterAmountValue = session.waterAmount != nil ? String(format: "%.0fml", session.waterAmount!) : "Nicht angegeben"
            SessionDetailRow(
                title: "Wassermenge",
                value: waterAmountValue,
                isEditing: isEditing
            ) {
                HStack {
                    TextField("Menge", value: waterAmountBinding, format: .number)
                    Text("ml")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var tastingProfileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Geschmacksprofil")
                .font(.headline)
            
            Group {
                if isEditing {
                    editingTastingProfile
                } else {
                    displayTastingProfile
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var editingTastingProfile: some View {
        Group {
            RatingSlider(title: "Aroma", value: $session.aroma)
            RatingSlider(title: "Säure", value: $session.acidity)
            RatingSlider(title: "Körper", value: $session.body)
            RatingSlider(title: "Geschmack", value: $session.flavor)
            RatingSlider(title: "Nachgeschmack", value: $session.aftertaste)
        }
    }
    
    private var displayTastingProfile: some View {
        Group {
            TastingProfileRow(title: "Aroma", value: session.aroma)
            TastingProfileRow(title: "Säure", value: session.acidity)
            TastingProfileRow(title: "Körper", value: session.body)
            TastingProfileRow(title: "Geschmack", value: session.flavor)
            TastingProfileRow(title: "Nachgeschmack", value: session.aftertaste)
        }
    }
    
    private var tastingNotesSection: some View {
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
            
            tastingNotesContent
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var tastingNotesContent: some View {
        Group {
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
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notizen")
                .font(.headline)
            
            Group {
                if isEditing {
                    TextField("Notizen zu diesem Durchlauf", text: $session.sessionNotes, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                } else {
                    notesContent
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var notesContent: some View {
        Group {
            if session.sessionNotes.isEmpty {
                Text("Keine Notizen hinzugefügt")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                Text(session.sessionNotes)
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
            }
            
            Spacer()
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
            
            Text(String(format: "%.1f", value))
                .foregroundColor(.secondary)
                .font(.caption)
            
            Spacer()
        }
    }
}
