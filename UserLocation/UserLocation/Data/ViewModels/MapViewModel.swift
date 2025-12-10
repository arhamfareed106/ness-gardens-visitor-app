//
//  MapViewModel.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import CoreLocation
import Foundation
import MapKit

/// View model for the map view controller
@MainActor
class MapViewModel: ObservableObject {
    /// A waypoint from the GPX file
    struct Waypoint: Hashable {
        let coordinate: CLLocationCoordinate2D
        let elevation: Double
        let timestamp: Date
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(coordinate.latitude)
            hasher.combine(coordinate.longitude)
            hasher.combine(elevation)
            hasher.combine(timestamp)
        }
        
        static func == (lhs: Waypoint, rhs: Waypoint) -> Bool {
            return lhs.coordinate.latitude == rhs.coordinate.latitude &&
                   lhs.coordinate.longitude == rhs.coordinate.longitude &&
                   lhs.elevation == rhs.elevation &&
                   lhs.timestamp == rhs.timestamp
        }
    }
    
    /// A map annotation representing a bed
    struct BedAnnotation: Hashable {
        let id = UUID()
        let bedID: String
        let title: String
        let coordinate: CLLocationCoordinate2D
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(bedID)
            hasher.combine(title)
            hasher.combine(coordinate.latitude)
            hasher.combine(coordinate.longitude)
        }
        
        static func == (lhs: BedAnnotation, rhs: BedAnnotation) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.bedID == rhs.bedID &&
                   lhs.title == rhs.title &&
                   lhs.coordinate.latitude == rhs.coordinate.latitude &&
                   lhs.coordinate.longitude == rhs.coordinate.longitude
        }
    }
    
    @Published var waypoints: [Waypoint] = []
    @Published var bedAnnotations: [BedAnnotation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let gpxFilePath: String
    
    init(gpxFilePath: String = Bundle.main.path(forResource: "NessWalk 25-Nov-2023 v2", ofType: "gpx") ?? "") {
        self.gpxFilePath = gpxFilePath
    }
    
    /// Loads and parses the GPX file
    func loadGPXFile() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let waypoints = try self.parseGPXFile()
                DispatchQueue.main.async {
                    self.waypoints = waypoints
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load GPX file: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    /// Parses the GPX file and extracts waypoints
    private func parseGPXFile() throws -> [Waypoint] {
        // Check if file exists
        guard FileManager.default.fileExists(atPath: gpxFilePath) else {
            throw NSError(domain: "MapViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "GPX file not found"])
        }
        
        let xmlString = try String(contentsOfFile: gpxFilePath)
        return try parseWaypoints(from: xmlString)
    }
    
    /// Parses waypoints from XML string
    private func parseWaypoints(from xmlString: String) throws -> [Waypoint] {
        var waypoints: [Waypoint] = []
        
        // Simple XML parsing - in a production app, you'd use a proper XML parser
        let wptPattern = "<wpt lat=\"([^\"]+)\" lon=\"([^\"]+)\">[^<]*<ele>([^<]+)</ele>[^<]*<time>([^<]+)</time>"
        let regex = try NSRegularExpression(pattern: wptPattern, options: [])
        let nsString = xmlString as NSString
        let results = regex.matches(in: xmlString, options: [], range: NSRange(location: 0, length: nsString.length))
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        for result in results {
            let latRange = result.range(at: 1)
            let lonRange = result.range(at: 2)
            let eleRange = result.range(at: 3)
            let timeRange = result.range(at: 4)
            
            guard latRange.location != NSNotFound,
                  lonRange.location != NSNotFound,
                  eleRange.location != NSNotFound,
                  timeRange.location != NSNotFound else {
                continue
            }
            
            let latString = nsString.substring(with: latRange)
            let lonString = nsString.substring(with: lonRange)
            let eleString = nsString.substring(with: eleRange)
            let timeString = nsString.substring(with: timeRange)
            
            guard let latitude = Double(latString),
                  let longitude = Double(lonString),
                  let elevation = Double(eleString),
                  let timestamp = formatter.date(from: timeString) else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let waypoint = Waypoint(coordinate: coordinate, elevation: elevation, timestamp: timestamp)
            waypoints.append(waypoint)
        }
        
        return waypoints
    }
    
    /// Filters pins based on zoom level (simple clustering strategy)
    /// - Parameter region: The current map region
    /// - Returns: Filtered annotations
    func filterAnnotations(for region: MKCoordinateRegion) -> [BedAnnotation] {
        // For simplicity, we're returning all annotations
        // In a real app, you would implement clustering based on zoom level
        return bedAnnotations
    }
    
    /// Updates bed annotations from Core Data
    func updateBedAnnotations() async {
        do {
            let beds = try await fetchBedsFromCoreData()
            let annotations = beds.map { bed -> BedAnnotation in
                let coordinate = CLLocationCoordinate2D(latitude: bed.latitude, longitude: bed.longitude)
                return BedAnnotation(bedID: bed.bedID, title: bed.name, coordinate: coordinate)
            }
            
            await MainActor.run {
                self.bedAnnotations = annotations
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load beds: \(error.localizedDescription)"
            }
        }
    }
    
    /// Fetches beds from Core Data
    private func fetchBedsFromCoreData() async throws -> [Bed] {
        return try await CoreDataStack.shared.context.perform {
            let request: NSFetchRequest<Bed> = Bed.fetchRequest()
            return try CoreDataStack.shared.context.fetch(request)
        }
    }
}