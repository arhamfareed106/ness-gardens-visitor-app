//
//  PlantCell.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import UIKit

/// Custom table view cell for displaying plant information
class PlantCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var plantItem: PlantItem?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Configure the cell's appearance
        accessoryType = .disclosureIndicator
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with a plant item
    /// - Parameter plantItem: The plant item to display
    func configure(with plantItem: PlantItem) {
        self.plantItem = plantItem
        
        var content = UIListContentConfiguration.subtitleCell()
        content.text = plantItem.latinName
        content.secondaryText = plantItem.commonName
        
        // Add distance information if available
        if let distance = plantItem.distance {
            content.secondaryText = "\(plantItem.commonName) - \(String(format: "%.0f", distance))m away"
        }
        
        contentConfiguration = content
    }
    
    /// Resets the cell's content
    override func prepareForReuse() {
        super.prepareForReuse()
        plantItem = nil
    }
}