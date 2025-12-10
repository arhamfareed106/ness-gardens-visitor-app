//
//  CoreDataStack.swift
//  UserLocation
//
//  Created by Ness Gardens Developer on 09/12/2025.
//

import CoreData
import Foundation

/// A singleton class that manages the Core Data stack for the Ness Gardens app
class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    /// The persistent container for the Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NessGardens")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    /// The main managed object context for the app
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Saves the current context if there are any changes
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Performs a background save operation
    /// - Parameter block: The block to execute with a background context
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}