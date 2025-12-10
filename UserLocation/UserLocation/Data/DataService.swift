//
//  DataService.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import Foundation

class DataService {
    static let shared = DataService()
    
    private init() {}
    
    /// Performs a complete synchronization of all data
    func synchronizeAllData() async throws {
        // Sync beds first since plants reference them
        try await SyncEngine.shared.syncBeds()
        
        // Sync plants
        try await SyncEngine.shared.syncPlants()
        
        // Establish relationships between plants and beds
        try await SyncEngine.shared.establishPlantBedRelationships()
    }
}