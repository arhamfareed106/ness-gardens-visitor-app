//
//  PlantListViewModel.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import CoreLocation
import Foundation

/// View model for the plant list view controller
@MainActor
class PlantListViewModel: ObservableObject {
    @Published var sections: [PlantSection] = []
    @Published var plantItems: [PlantSection: [PlantItem]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var allBeds: [Bed] = []
    private var allPlants: [Plant] = []
    
    /// Loads data from Core Data
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let beds = fetchBedsFromCoreData()
            async let plants = fetchPlantsFromCoreData()
            
            allBeds = try await beds
            allPlants = try await plants
            
            isLoading = false
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// Sorts beds by distance from user's location and updates the view model
    /// - Parameter userLocation: Current user location
    func sortBedsByDistance(from userLocation: CLLocation) {
        // Calculate distances for each bed
        let bedsWithDistances = allBeds.map { bed -> (bed: Bed, distance: Double) in
            let bedLocation = CLLocation(latitude: bed.latitude, longitude: bed.longitude)
            let distance = userLocation.distance(from: bedLocation)
            return (bed: bed, distance: distance)
        }
        
        // Sort by distance (nearest first)
        let sortedBeds = bedsWithDistances.sorted { $0.distance < $1.distance }
        
        // Create sections and items
        var newSections: [PlantSection] = []
        var newPlantItems: [PlantSection: [PlantItem]] = [:]
        
        for (bed, distance) in sortedBeds {
            let section = PlantSection(title: "\(bed.name) (\(String(format: "%.0f", distance))m)")
            newSections.append(section)
            
            // Get plants for this bed
            let plants = bed.plants.array as? [Plant] ?? []
            let plantItems = plants.map { plant in
                PlantItem(
                    id: plant.recnum,
                    latinName: plant.latinName,
                    commonName: plant.commonName,
                    distance: distance
                )
            }.sorted { $0.latinName < $1.latinName }
            
            newPlantItems[section] = plantItems
        }
        
        sections = newSections
        plantItems = newPlantItems
    }
    
    /// Fetches beds from Core Data
    private func fetchBedsFromCoreData() async throws -> [Bed] {
        return try await CoreDataStack.shared.context.perform {
            let request: NSFetchRequest<Bed> = Bed.fetchRequest()
            return try CoreDataStack.shared.context.fetch(request)
        }
    }
    
    /// Fetches plants from Core Data
    private func fetchPlantsFromCoreData() async throws -> [Plant] {
        return try await CoreDataStack.shared.context.perform {
            let request: NSFetchRequest<Plant> = Plant.fetchRequest()
            return try CoreDataStack.shared.context.fetch(request)
        }
    }
}