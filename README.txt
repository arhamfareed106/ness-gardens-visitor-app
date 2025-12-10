NESS GARDENS VISITOR APP - COMP228 ASSIGNMENT SUBMISSION

PROJECT STRUCTURE:
==================
UserLocation/
├── UserLocation/                  # Main app source code
│   ├── AppDelegate.swift           # Application delegate
│   ├── SceneDelegate.swift         # Scene delegate with navigation setup
│   ├── MainViewController.swift    # Main entry point with navigation options
│   ├── MapViewController.swift     # Map view with garden layout
│   ├── PlantListViewController.swift # Plant list organized by beds
│   ├── PlantCell.swift            # Custom table view cell for plants
│   ├── PlantDetailViewController.swift # Detailed plant information view
│   ├── Info.plist                 # App configuration and permissions
│   ├── Base.lproj/               # Storyboards
│   │   ├── Main.storyboard       # Main UI layout
│   │   └── LaunchScreen.storyboard # Launch screen
│   ├── Assets.xcassets/          # App assets and icons
│   └── Data/                     # Data layer (Core Data, ViewModels, etc.)
│       ├── CoreDataStack.swift    # Core Data setup and management
│       ├── SyncEngine.swift       # Data synchronization from API
│       ├── APIModels.swift        # Data models for API responses
│       ├── DataService.swift      # High-level data operations
│       ├── Utilities.swift        # Helper extensions
│       ├── Models/               # Data models for UI
│       │   ├── PlantItem.swift
│       │   └── PlantSection.swift
│       ├── ViewModels/           # View models for UI logic
│       │   ├── MapViewModel.swift
│       │   └── PlantListViewModel.swift
│       └── Entities/             # Core Data entities
│           ├── Bed+CoreDataClass.swift
│           ├── Bed+CoreDataProperties.swift
│           ├── Plant+CoreDataClass.swift
│           └── Plant+CoreDataProperties.swift
├── UserLocation.xcodeproj/       # Xcode project files
└── ../NessWalk 25-Nov-2023 v2.gpx # GPX file for location simulation

FEATURES IMPLEMENTED:
====================
1. Core Data persistence with proper entity relationships
2. Network synchronization with API using async/await
3. Plant filtering (only accsta == "C" plants)
4. Bed string parsing for many-to-many relationships
5. Location-based sorting of plants by bed proximity
6. Map view with annotations
7. Plant list with diffable data source
8. Plant detail view with mini-map
9. GPX file simulation support

TECHNICAL SPECIFICATIONS:
========================
- Language: Swift 6 with Strict Concurrency
- UI Framework: UIKit with Storyboards
- Architecture: MVVM
- Networking: Native URLSession with async/await
- Persistence: Core Data
- Location Services: CoreLocation
- Map Framework: MapKit

HOW TO RUN:
===========
1. Open UserLocation.xcodeproj in Xcode
2. Build and run the project
3. The app will automatically sync data from the API on first launch
4. Grant location permissions when prompted
5. Use the simulator's location simulation feature with the provided GPX file