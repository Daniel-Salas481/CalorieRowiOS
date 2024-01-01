//
//  FoodEaten+CoreDataProperties.swift
//  
//
//  Created by Daniel Salas on 11/14/21.
//
//

import Foundation
import CoreData


extension FoodEaten {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEaten> {
        return NSFetchRequest<FoodEaten>(entityName: "FoodEaten")
    }

    @NSManaged public var foodName: String?
    @NSManaged public var calories: Double

}
