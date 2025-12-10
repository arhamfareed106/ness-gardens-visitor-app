//
//  SyncEngine.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import CoreData
import Foundation

/// An actor responsible for synchronizing data between the API and Core Data
actor SyncEngine {
    static let shared = SyncEngine()
    
    private init() {}
    
    /// Fetches and synchronizes plants data from the API
    func syncPlants() async throws {
        let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=plants")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode([String: [APIPlant]].self, from: data)
        guard let apiPlants = apiResponse["plants"] else { return }
        
        // Filter plants where accsta == "C"
        let filteredPlants = apiPlants.filter { $0.accsta == "C" }
        
        // Perform batch insert/update
        try await CoreDataStack.shared.context.perform {
            // Get existing plants
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            let existingPlants = try CoreDataStack.shared.context.fetch(fetchRequest)
            var existingPlantDict = [String: Plant]()
            
            for plant in existingPlants {
                existingPlantDict[plant.recnum] = plant
            }
            
            // Process API plants
            for apiPlant in filteredPlants {
                let plant: Plant
                if let existingPlant = existingPlantDict[apiPlant.recnum] {
                    plant = existingPlant
                } else {
                    plant = Plant(context: CoreDataStack.shared.context)
                }
                
                plant.recnum = apiPlant.recnum
                plant.latinName = "\(apiPlant.genus ?? "") \(apiPlant.species ?? "")".trimmingCharacters(in: .whitespaces)
                plant.commonName = apiPlant.vernacularName ?? ""
                plant.isFavorite = false
                plant.accsta = apiPlant.accsta ?? ""
                // Store the bed string for later relationship processing
                plant.setValue(apiPlant.bed, forKey: "bed")
            }
            
            try CoreDataStack.shared.context.save()
        }
    }
    
    /// Fetches and synchronizes beds data from the API
    func syncBeds() async throws {
        let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/ness/data.php?class=beds")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode([String: [APIBed]].self, from: data)
        guard let apiBeds = apiResponse["beds"] else { return }
        
        // Perform batch insert/update
        try await CoreDataStack.shared.context.perform {
            // Get existing beds
            let fetchRequest: NSFetchRequest<Bed> = Bed.fetchRequest()
            let existingBeds = try CoreDataStack.shared.context.fetch(fetchRequest)
            var existingBedDict = [String: Bed]()
            
            for bed in existingBeds {
                existingBedDict[bed.bedID] = bed
            }
            
            // Process API beds
            for apiBed in apiBeds {
                let bed: Bed
                if let existingBed = existingBedDict[apiBed.bedID] {
                    bed = existingBed
                } else {
                    bed = Bed(context: CoreDataStack.shared.context)
                }
                
                bed.bedID = apiBed.bedID
                bed.name = apiBed.name
                bed.latitude = Double(apiBed.latitude) ?? 0.0
                bed.longitude = Double(apiBed.longitude) ?? 0.0
            }
            
            try CoreDataStack.shared.context.save()
        }
    }
    
    /// Establishes relationships between plants and beds based on the bed string
    func establishPlantBedRelationships() async throws {
        try await CoreDataStack.shared.context.perform {
            // Fetch all plants and beds
            let plantRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            let bedRequest: NSFetchRequest<Bed> = Bed.fetchRequest()
            
            let plants = try CoreDataStack.shared.context.fetch(plantRequest)
            let beds = try CoreDataStack.shared.context.fetch(bedRequest)
            
            // Create a dictionary for quick bed lookup
            var bedDict = [String: Bed]()
            for bed in beds {
                bedDict[bed.bedID] = bed
            }
            
            // Process each plant to establish relationships
            for plant in plants {
                // Get the stored bed string
                guard let bedString = plant.value(forKey: "bed") as? String,
                      !bedString.isEmpty else { 
                    // Clear existing relationships if no bed string
                    plant.beds = Set<Bed>()
                    continue 
                }
                
                // Split the bed string by whitespace
                let bedIDs = bedString.split(whereSeparator: \.isWhitespace).map(String.init)
                
                // Create a set to hold the related beds
                var bedSet = Set<Bed>()
                
                for bedID in bedIDs {
                    if let bed = bedDict[bedID] {
                        bedSet.insert(bed)
                    }
                    // Fault tolerance: if a bed doesn't exist, we simply skip it
                }
                
                // Set the relationship
                plant.beds = bedSet
            }
            
            try CoreDataStack.shared.context.save()
        }
    }
    
    /// Synchronizes all data from the API
    func syncAll() async throws {
        try await syncBeds()
        try await syncPlants()
        try await establishPlantBedRelationships()
    }
}