//
//  Plant+CoreDataProperties.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import Foundation
import CoreData

extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var recnum: String
    @NSManaged public var latinName: String
    @NSManaged public var commonName: String
    @NSManaged public var isFavorite: Bool
    @NSManaged public var accsta: String
    @NSManaged public var beds: Set<Bed>

}

// MARK: Generated accessors for beds
extension Plant {

    @objc(addBedsObject:)
    @NSManaged public func addToBeds(_ value: Bed)

    @objc(removeBedsObject:)
    @NSManaged public func removeFromBeds(_ value: Bed)

    @objc(addBeds:)
    @NSManaged public func addToBeds(_ values: Set<Bed>)

    @objc(removeBeds:)
    @NSManaged public func removeFromBeds(_ values: Set<Bed>)

}