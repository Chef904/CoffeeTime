//
//  ContentView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var dataManager = CoffeeDataManager.shared
    @State private var showingAddCoffee = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                if dataManager.coffees.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.brown)
                        Text("Noch keine Kaffeesorten")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("Fügen Sie Ihre erste Kaffeesorte hinzu!")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(dataManager.coffees.sorted(by: { $0.dateAdded > $1.dateAdded })) { coffee in
                            NavigationLink(destination: CoffeeDetailView(coffee: coffee, dataManager: dataManager)) {
                                CoffeeRow(coffee: coffee)
                            }
                        }
                        .onDelete(perform: deleteCoffees)
                    }
                }
            }
            .navigationTitle("Kaffee Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCoffee = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCoffee) {
                AddCoffeeView(dataManager: dataManager)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
    
    func deleteCoffees(offsets: IndexSet) {
        let sortedCoffees = dataManager.coffees.sorted(by: { $0.dateAdded > $1.dateAdded })
        for index in offsets {
            dataManager.deleteCoffee(sortedCoffees[index])
        }
    }
}

struct CoffeeRow: View {
    let coffee: Coffee
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(coffee.name)
                    .font(.headline)
                Spacer()
                if coffee.averageRating > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(coffee.averageRating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                        Text(String(format: "%.1f", coffee.averageRating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            HStack {
                if let origin = coffee.origin {
                    Text(origin)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Text(coffee.roastLevel.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.brown.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
                
                Text("\(coffee.brewingSessions?.count ?? 0) Durchläufe")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !coffee.coffeeDescription.isEmpty {
                Text(coffee.coffeeDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            if let price = coffee.price {
                Text(price.formatted(.currency(code: "EUR")))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
