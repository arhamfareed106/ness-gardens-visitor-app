//
//  Utilities.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import CoreLocation
import Foundation

extension CLLocation {
    /// Calculates the distance in meters between two CLLocation points
    /// - Parameter location: The other location to calculate distance to
    /// - Returns: Distance in meters
    func distance(from location: CLLocation) -> CLLocationDistance {
        return self.distance(from: location)
    }
    
    /// Creates a CLLocation from latitude and longitude strings
    /// - Parameters:
    ///   - latitude: Latitude as String
    ///   - longitude: Longitude as String
    /// - Returns: CLLocation object or nil if conversion fails
    static func from(latitude: String, longitude: String) -> CLLocation? {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            return nil
        }
        return CLLocation(latitude: lat, longitude: lon)
    }
}