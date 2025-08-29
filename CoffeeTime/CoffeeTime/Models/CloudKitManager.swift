//
//  CloudKitManager.swift
//  CoffeeTime
//
//  Created by Johannes Tourbeslis on 29.08.25.
//

import CloudKit
import Foundation

class CloudKitManager: ObservableObject {
    @Published var isCloudKitAvailable = false
    @Published var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published var syncStatus: String = "Prüfe iCloud Status..."
    
    init() {
        checkCloudKitStatus()
    }
    
    func checkCloudKitStatus() {
        CKContainer.default().accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                self?.accountStatus = status
                self?.isCloudKitAvailable = (status == .available)
                self?.updateSyncStatus(status: status, error: error)
            }
        }
    }
    
    private func updateSyncStatus(status: CKAccountStatus, error: Error?) {
        switch status {
        case .available:
            syncStatus = "iCloud Sync aktiviert"
        case .noAccount:
            syncStatus = "Kein iCloud Account"
        case .restricted:
            syncStatus = "iCloud eingeschränkt"
        case .couldNotDetermine:
            syncStatus = "iCloud Status unbekannt"
        case .temporarilyUnavailable:
            syncStatus = "iCloud temporär nicht verfügbar"
        @unknown default:
            syncStatus = "iCloud Status unbekannt"
        }
        
        if let error = error {
            syncStatus = "iCloud Fehler: \(error.localizedDescription)"
        }
    }
}