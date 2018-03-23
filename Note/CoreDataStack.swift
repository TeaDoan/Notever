//
//  CoreDataStack.swift
//  Scrappr
//
//  Created by Steve Uffelman on 6/26/17.
//  Copyright © 2017 Steve Uffelman. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    private let documentsDir = FileManager.default.documentsDirectory()
    static let shared = CoreDataStack()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let err = error {
                print("CoreData error \(err), \(err._userInfo!)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
}
