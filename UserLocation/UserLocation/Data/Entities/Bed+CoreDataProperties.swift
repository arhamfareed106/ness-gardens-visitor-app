//
//  Bed+CoreDataProperties.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import Foundation
import CoreData

extension Bed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bed> {
        return NSFetchRequest<Bed>(entityName: "Bed")
    }

    @NSManaged public var bedID: String
    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var plants: Set<Plant>

}

// MARK: Generated accessors for plants
extension Bed {

    @objc(addPlantsObject:)
    @NSManaged public func addToPlants(_ value: Plant)

    @objc(removePlantsObject:)
    @NSManaged public func removeFromPlants(_ value: Plant)

    @objc(addPlants:)
    @NSManaged public func addToPlants(_ values: Set<Plant>)

    @objc(removePlants:)
    @NSManaged public func removeFromPlants(_ values: Set<Plant>)

}