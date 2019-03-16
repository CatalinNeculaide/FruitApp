//
//  CoreDataManager.swift
//  FruitAppTake2
//
//  Created by Catalin Neculaide on 15/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static var mainViewContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    class public func saveMainContext(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    
    class public func getFruits() -> [Fruits]? {
        
        let fruitsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Fruits")
        fruitsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        
        do {
            let fetchedFruits = try CoreDataManager.mainViewContext.fetch(fruitsFetchRequest) as! [Fruits]
            if fetchedFruits.count > 0 {
                return fetchedFruits
            } else {
                return nil
            }
        } catch {
            fatalError("failed to fetch Fruits: \(error)")
        }
    }
    
    class public func getFruitsType(type: String) -> [Fruits]? {
        
        let fruitsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Fruits")
        fruitsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fruitsFetchRequest.predicate = NSPredicate(format: "type = %@", type)
        
        do{
            let fetchedFruits = try CoreDataManager.mainViewContext.fetch(fruitsFetchRequest) as! [Fruits]
            if fetchedFruits.count > 0 {
                return fetchedFruits
            } else {
                return nil
            }
        } catch {
            fatalError("Error fetching fruits by type \(type) with error: \(error)")
        }
    }
}
