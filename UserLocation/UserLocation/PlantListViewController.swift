//
//  PlantListViewController.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import UIKit
import CoreLocation

/// View controller for displaying the list of plants organized by beds
class PlantListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let viewModel = PlantListViewModel()
    private let locationManager = CLLocationManager()
    
    // MARK: - Diffable Data Source
    
    private var dataSource: UITableViewDiffableDataSource<PlantSection, PlantItem>!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        setupDataSource()
        setupLocationManager()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Plants by Bed"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(PlantCell.self, forCellReuseIdentifier: "PlantCell")
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<PlantSection, PlantItem>(tableView: tableView) { tableView, indexPath, plantItem in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as! PlantCell
            cell.configure(with: plantItem)
            return cell
        }
        
        dataSource.defaultRowAnimation = .fade
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Data Loading
    
    private func loadData() {
        Task {
            await viewModel.loadData()
            
            // Request location after data is loaded
            DispatchQueue.main.async {
                self.locationManager.requestLocation()
            }
        }
    }
    
    // MARK: - UI Updates
    
    private func updateUI(with userLocation: CLLocation) {
        viewModel.sortBedsByDistance(from: userLocation)
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<PlantSection, PlantItem>()
        snapshot.appendSections(viewModel.sections)
        
        for section in viewModel.sections {
            if let items = viewModel.plantItems[section] {
                snapshot.appendItems(items, toSection: section)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDataSource

extension PlantListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        return viewModel.plantItems[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        let plantItem = viewModel.plantItems[section]?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as! PlantCell
        
        if let plantItem = plantItem {
            cell.configure(with: plantItem)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
}

// MARK: - UITableViewDelegate

extension PlantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = viewModel.sections[indexPath.section]
        guard let plantItem = viewModel.plantItems[section]?[indexPath.row] else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "PlantDetailViewController") as? PlantDetailViewController {
            detailViewController.plantItem = plantItem
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension PlantListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        updateUI(with: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error)")
        
        // Use a default location (Ness Gardens) if location services fail
        let nessGardensLocation = CLLocation(latitude: 53.27566, longitude: -3.04122)
        updateUI(with: nessGardensLocation)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            // Use a default location (Ness Gardens) if location services are denied
            let nessGardensLocation = CLLocation(latitude: 53.27566, longitude: -3.04122)
            updateUI(with: nessGardensLocation)
        default:
            break
        }
    }
}