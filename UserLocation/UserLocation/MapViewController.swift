//
//  MapViewController.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import UIKit
import MapKit
import CoreLocation
import Combine

/// View controller for displaying the map with bed locations
class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private let viewModel = MapViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocationManager()
        setupMapView()
        setupBindings()
        
        // Load GPX data
        viewModel.loadGPXFile()
        
        // Load bed annotations
        Task {
            await viewModel.updateBedAnnotations()
            // Update UI on main thread
            DispatchQueue.main.async { [weak self] in
                self?.updateMapAnnotations(self?.viewModel.bedAnnotations ?? [])
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Ness Gardens Map"
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // Center on Ness Gardens location (53.27566, -3.04122)
        let nessGardensLocation = CLLocationCoordinate2D(latitude: 53.27566, longitude: -3.04122)
        let region = MKCoordinateRegion(center: nessGardensLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
    }
    
    private func setupBindings() {
        // We'll manually check for updates in this implementation
        // In a more advanced implementation, you might use Combine or delegate pattern
    }
    
    // MARK: - Map Updates
    
    private func updateMapAnnotations(_ annotations: [MapViewModel.BedAnnotation]) {
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        
        // Add new annotations
        let mapAnnotations = annotations.map { annotation in
            let mapAnnotation = MKPointAnnotation()
            mapAnnotation.coordinate = annotation.coordinate
            mapAnnotation.title = annotation.title
            return mapAnnotation
        }
        
        mapView.addAnnotations(mapAnnotations)
    }
    
    // MARK: - Error Handling
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Update map region if needed
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Stop location updates to conserve battery
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Show alert to user to enable location services
            let alert = UIAlertController(
                title: "Location Services Disabled",
                message: "Please enable location services in Settings to view your location on the map.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        default:
            break
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't customize the user location annotation
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "BedAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = UIColor.systemGreen
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}