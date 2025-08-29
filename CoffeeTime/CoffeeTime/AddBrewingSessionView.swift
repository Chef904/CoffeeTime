//
//  AddBrewingSessionView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct AddBrewingSessionView: View {
    let coffee: Coffee
    @ObservedObject var dataManager: CoffeeDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var session = BrewingSession()
    @State private var newTastingNote = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Zubereitung") {
                    TextField("Mühle/Grinder", text: $session.grinder)
                    
                    Picker("Mahlgrad", selection: $session.grindLevel) {
                        ForEach(GrindLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    Picker("Zubereitungsart", selection: $session.brewMethod) {
                        ForEach(BrewMethod.allCases, id: \.self) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                }
                
                Section("Parameter (Optional)") {
                    HStack {
                        Text("Wassertemperatur")
                        Spacer()
                        TextField("°C", value: $session.waterTemperature, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Text("°C")
                    }
                    
                    HStack {
                        Text("Brühzeit")
                        Spacer()
                        TextField("Sekunden", value: Binding(
                            get: { session.brewTime ?? 0 },
                            set: { session.brewTime = $0 > 0 ? $0 : nil }
                        ), format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Text("sec")
                    }
                    
                    HStack {
                        Text("Kaffeemenge")
                        Spacer()
                        TextField("Gramm", value: $session.coffeeAmount, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Text("g")
                    }
                    
                    HStack {
                        Text("Wassermenge")
                        Spacer()
                        TextField("ml", value: $session.waterAmount, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Text("ml")
                    }
                }
                
                Section("Geschmacksprofil") {
                    VStack(alignment: .leading, spacing: 12) {
                        RatingSlider(title: "Gesamtbewertung", value: $session.rating)
                        RatingSlider(title: "Aroma", value: $session.aroma)
                        RatingSlider(title: "Säure", value: $session.acidity)
                        RatingSlider(title: "Körper", value: $session.body)
                        RatingSlider(title: "Geschmack", value: $session.flavor)
                        RatingSlider(title: "Nachgeschmack", value: $session.aftertaste)
                    }
                }
                
                Section("Geschmacksnotizen") {
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
                    
                    ForEach(session.tastingNotes.indices, id: \.self) { index in
                        HStack {
                            Text(session.tastingNotes[index])
                            Spacer()
                            Button("Entfernen") {
                                session.tastingNotes.remove(at: index)
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                
                Section("Notizen") {
                    TextField("Notizen zu diesem Durchlauf", text: $session.sessionNotes, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                }
            }
            .navigationTitle("Neuer Durchlauf")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        dataManager.addBrewingSession(session, to: coffee)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

