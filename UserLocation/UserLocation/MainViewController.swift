//
//  MainViewController.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import UIKit

/// Main view controller that serves as the entry point for the app
class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapViewButton: UIButton!
    @IBOutlet weak var plantListButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Ness Gardens"
        view.backgroundColor = UIColor.systemBackground
        
        // Configure buttons
        setupButton(mapViewButton, title: "Garden Map", systemImage: "map.fill")
        setupButton(plantListButton, title: "Plants by Bed", systemImage: "list.bullet")
    }
    
    private func setupButton(_ button: UIButton, title: String, systemImage: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: systemImage)
        config.imagePlacement = .top
        config.imagePadding = 8
        config.cornerStyle = .medium
        
        button.configuration = config
    }
    
    // MARK: - Actions
    
    @IBAction func mapViewButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    @IBAction func plantListButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let plantListViewController = storyboard.instantiateViewController(withIdentifier: "PlantListViewController") as? PlantListViewController {
            navigationController?.pushViewController(plantListViewController, animated: true)
        }
    }
}