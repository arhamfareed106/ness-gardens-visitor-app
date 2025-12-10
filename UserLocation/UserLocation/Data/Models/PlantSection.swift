//
//  PlantSection.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import Foundation

/// A section in the plant list view
struct PlantSection: Hashable {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: PlantSection, rhs: PlantSection) -> Bool {
        return lhs.title == rhs.title
    }
}