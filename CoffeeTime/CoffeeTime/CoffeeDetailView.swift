//
//  CoffeeDetailView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct CoffeeDetailView: View {
    @State var coffee: Coffee
    @Bindable var dataManager: CoffeeDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing = false
    @State private var showingAddSession = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    if isEditing {
                        TextField("Kaffee Name", text: $coffee.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    } else {
                        Text(coffee.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Text("Hinzugefügt: \(coffee.dateAdded, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Coffee Info Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Kaffee Details")
                        .font(.headline)
                    
                    DetailRow(title: "Herkunft", value: coffee.origin ?? "Unbekannt", isEditing: isEditing) {
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
                    }
                    
                    DetailRow(title: "Rösterei", value: coffee.roaster ?? "Nicht angegeben", isEditing: isEditing) {
                        TextField("Rösterei", text: Binding(
                            get: { coffee.roaster ?? "" },
                            set: { coffee.roaster = $0.isEmpty ? nil : $0 }
                        ))
                    }
                    
                    DetailRow(title: "Preis", value: coffee.price?.formatted(.currency(code: "EUR")) ?? "Nicht angegeben", isEditing: isEditing) {
                        TextField("Preis", value: $coffee.price, format: .currency(code: "EUR"))
                    }
                    
                    DetailRow(title: "Röstgrad", value: coffee.roastLevel.rawValue, isEditing: isEditing) {
                        Picker("Röstgrad", selection: $coffee.roastLevel) {
                            ForEach(RoastLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Beschreibung")
                            .fontWeight(.medium)
                        
                        if isEditing {
                            TextField("Beschreibung", text: $coffee.coffeeDescription, axis: .vertical)
                                .lineLimit(4, reservesSpace: true)
                        } else {
                            if coffee.coffeeDescription.isEmpty {
                                Text("Keine Beschreibung")
                                    .foregroundColor(.secondary)
                                    .italic()
                            } else {
                                Text(coffee.coffeeDescription)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Average Rating Section
                if coffee.averageRating > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Durchschnittsbewertung")
                            .font(.headline)
                        
                        HStack {
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: Double(index) < coffee.averageRating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.title2)
                                }
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.1f/5.0", coffee.averageRating))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Text("Basierend auf \(coffee.brewingSessions.count) Durchläufen")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Brewing Sessions Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Zubereitungsdurchläufe (\(coffee.brewingSessions.count))")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button("Neuer Durchlauf") {
                            showingAddSession = true
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    if coffee.brewingSessions.isEmpty {
                        Text("Noch keine Zubereitungsdurchläufe hinzugefügt")
                            .foregroundColor(.secondary)
                            .italic()
                            .padding()
                    } else {
                        ForEach(coffee.brewingSessions.sorted(by: { $0.date > $1.date })) { session in
                            NavigationLink(destination: BrewingSessionDetailView(session: session, coffee: coffee, dataManager: dataManager)) {
                                BrewingSessionRow(session: session)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .navigationTitle("Kaffee Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Speichern" : "Bearbeiten") {
                    if isEditing {
                        dataManager.updateCoffee(coffee)
                    }
                    isEditing.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddSession) {
            AddBrewingSessionView(coffee: coffee, dataManager: dataManager)
        }
    }
}

struct BrewingSessionRow: View {
    let session: BrewingSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(session.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(session.rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            
            HStack {
                Text(session.brewMethod.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                
                Text(session.grindLevel.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
                
                if !session.grinder.isEmpty {
                    Text(session.grinder)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            if !session.sessionNotes.isEmpty {
                Text(session.sessionNotes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
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
