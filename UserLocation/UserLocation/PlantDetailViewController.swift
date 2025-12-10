//
//  PlantDetailViewController.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import UIKit
import MapKit
import CoreLocation

/// View controller for displaying detailed information about a plant
class PlantDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var latinNameLabel: UILabel!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var originMapView: MKMapView!
    @IBOutlet weak var originLabel: UILabel!
    
    // MARK: - Properties
    
    var plantItem: PlantItem?
    private var plant: Plant?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupOriginMap()
        loadPlantData()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Plant Details"
        
        // Configure image view
        plantImageView.contentMode = .scaleAspectFit
        plantImageView.layer.cornerRadius = 8
        plantImageView.clipsToBounds = true
        
        // Configure labels
        latinNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        latinNameLabel.numberOfLines = 0
        
        commonNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        commonNameLabel.textColor = UIColor.secondaryLabel
        commonNameLabel.numberOfLines = 0
        
        originLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        originLabel.textColor = UIColor.secondaryLabel
        originLabel.numberOfLines = 0
        
        // Add some padding to the content view
        contentView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private func setupOriginMap() {
        originMapView.delegate = self
        originMapView.layer.cornerRadius = 8
        originMapView.clipsToBounds = true
        
        // Hide map controls for a cleaner look
        originMapView.showsUserLocation = false
        originMapView.isZoomEnabled = false
        originMapView.isScrollEnabled = false
        originMapView.isUserInteractionEnabled = false
    }
    
    // MARK: - Data Loading
    
    private func loadPlantData() {
        guard let plantItem = plantItem else { return }
        
        // Update UI with basic plant information
        latinNameLabel.text = plantItem.latinName
        commonNameLabel.text = plantItem.commonName
        
        // Load full plant data from Core Data
        Task {
            await loadFullPlantData(recnum: plantItem.id)
        }
    }
    
    private func loadFullPlantData(recnum: String) async {
        do {
            let plant = try await fetchPlantFromCoreData(recnum: recnum)
            self.plant = plant
            
            await MainActor.run {
                updateUIWithPlantData(plant)
            }
        } catch {
            print("Failed to load plant data: \(error)")
        }
    }
    
    private func fetchPlantFromCoreData(recnum: String) async throws -> Plant {
        return try await CoreDataStack.shared.context.perform {
            let request: NSFetchRequest<Plant> = Plant.fetchRequest()
            request.predicate = NSPredicate(format: "recnum == %@", recnum)
            request.fetchLimit = 1
            
            let results = try CoreDataStack.shared.context.fetch(request)
            guard let plant = results.first else {
                throw NSError(domain: "PlantDetailViewController", code: 1, userInfo: [NSLocalizedDescriptionKey: "Plant not found"])
            }
            
            return plant
        }
    }
    
    // MARK: - UI Updates
    
    private func updateUIWithPlantData(_ plant: Plant) {
        // Update labels with additional information
        if !plant.latinName.isEmpty {
            latinNameLabel.text = plant.latinName
        }
        
        if !plant.commonName.isEmpty {
            commonNameLabel.text = plant.commonName
        }
        
        // Try to show origin information if available
        showOriginInformation(plant: plant)
        
        // TODO: Load plant image when image data is available
        plantImageView.image = UIImage(systemName: "leaf.fill")
        plantImageView.tintColor = UIColor.systemGreen
    }
    
    private func showOriginInformation(plant: Plant) {
        // Attempt to safely extract and convert latitude and longitude strings to Doubles.
        // Note: Assuming 'latitude' and 'longitude' are stored as optional Strings in the Core Data Plant entity.
        if let latitudeString = plant.latitude,
           let longitudeString = plant.longitude,
           let latitude = Double(latitudeString),
           let longitude = Double(longitudeString) {
            
            // 1. Show the map elements
            originMapView.isHidden = false
            
            // Display the country name if available, otherwise a generic label
            originLabel.text = plant.country ?? "Origin Information Available"
            
            // 2. Set the map's region
            let originCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // Set a wide region (1,000,000 meters) to show the country/continent scale
            let region = MKCoordinateRegion(center: originCoordinate, 
                                            latitudinalMeters: 1000000, 
                                            longitudinalMeters: 1000000)
            originMapView.setRegion(region, animated: false)
            
            // 3. Add the pin annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = originCoordinate
            annotation.title = plant.commonName
            // Clear any existing pins before adding the new one
            originMapView.removeAnnotations(originMapView.annotations)
            originMapView.addAnnotation(annotation)
            
        } else {
            // Hide map elements if origin data is missing
            originLabel.text = "Origin information not available"
            originMapView.isHidden = true
        }
    }
}

// MARK: - MKMapViewDelegate

extension PlantDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "OriginAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView?.markerTintColor = UIColor.systemGreen
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}