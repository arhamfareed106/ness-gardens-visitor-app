//
//  PlantItem.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import Foundation

/// A plant item for display in the list view
struct PlantItem: Hashable {
    let id: String
    let latinName: String
    let commonName: String
    let distance: Double?
    
    init(id: String, latinName: String, commonName: String, distance: Double? = nil) {
        self.id = id
        self.latinName = latinName
        self.commonName = commonName
        self.distance = distance
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PlantItem, rhs: PlantItem) -> Bool {
        return lhs.id == rhs.id
    }
}