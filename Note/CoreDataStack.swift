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
    //persistentContainer is the app database. Create a new NSPersistentContainer using "Model" data
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
    
    //context is temporory area where we can change things and update things that we want before we're happy to our changes then save it permernant our database.
    
    func saveContext(){
        let context = persistentContainer.viewContext

        if context.hasChanges
        {
            do {
                try context.save()
            } catch {

            let nserror = error as NSError
                    fatalError("Unresolved\("nserror"),\(nserror.userInfo)")
                }
            }
        }
}

