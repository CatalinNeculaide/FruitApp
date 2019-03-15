//
//  Fruits+CoreDataProperties.swift
//  FruitAppTake2
//
//  Created by Catalin Neculaide on 15/03/2019.
//  Copyright © 2019 Catalin Neculaide. All rights reserved.
//
//

import Foundation
import CoreData


extension Fruits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fruits> {
        return NSFetchRequest<Fruits>(entityName: "Fruits")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var type: String?

}
