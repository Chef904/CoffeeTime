//
//  ContentView.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 28.08.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = CoffeeDataManager()
    @State private var showingAddEntry = false
    
    var body: some View {
        NavigationView {
            VStack {
                if dataManager.coffeeEntries.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.brown)
                        Text("No Coffee Entries Yet")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("Start documenting your coffee journey!")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(dataManager.coffeeEntries.sorted(by: { $0.date > $1.date })) { entry in
                            NavigationLink(destination: CoffeeDetailView(entry: entry, dataManager: dataManager)) {
                                CoffeeEntryRow(entry: entry)
                            }
                        }
                        .onDelete(perform: deleteEntries)
                    }
                }
            }
            .navigationTitle("Coffee Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddEntry = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddCoffeeEntryView(dataManager: dataManager)
            }
        }
    }
    
    func deleteEntries(offsets: IndexSet) {
        let sortedEntries = dataManager.coffeeEntries.sorted(by: { $0.date > $1.date })
        for index in offsets {
            dataManager.deleteEntry(sortedEntries[index])
        }
    }
}

struct CoffeeEntryRow: View {
    let entry: CoffeeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.name)
                    .font(.headline)
                Spacer()
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(entry.rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            
            HStack {
                Text(entry.brewMethod.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                
                Text(entry.grindLevel.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(entry.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !entry.overallNotes.isEmpty {
                Text(entry.overallNotes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}
