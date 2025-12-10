//
//  UsageExample.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import Foundation
import CoreData

/*
 Example usage of the Core Data stack and synchronization engine:
 
 func synchronizeData() {
     Task {
         do {
             try await DataService.shared.synchronizeAllData()
             print("Data synchronization completed successfully")
         } catch {
             print("Data synchronization failed: \(error)")
         }
     }
 }
 
 func fetchAllBeds() -> [Bed] {
     let context = CoreDataStack.shared.context
     let request: NSFetchRequest<Bed> = Bed.fetchRequest()
     
     do {
         return try context.fetch(request)
     } catch {
         print("Failed to fetch beds: \(error)")
         return []
     }
 }
 
 func fetchPlantsInBed(bedID: String) -> [Plant] {
     let context = CoreDataStack.shared.context
     let request: NSFetchRequest<Plant> = Plant.fetchRequest()
     request.predicate = NSPredicate(format: "ANY beds.bedID == %@", bedID)
     
     do {
         return try context.fetch(request)
     } catch {
         print("Failed to fetch plants: \(error)")
         return []
     }
 }
 
 func togglePlantFavorite(plant: Plant) {
     let context = CoreDataStack.shared.context
     plant.isFavorite.toggle()
     
     do {
         try context.save()
     } catch {
         print("Failed to save favorite status: \(error)")
     }
 }
 */