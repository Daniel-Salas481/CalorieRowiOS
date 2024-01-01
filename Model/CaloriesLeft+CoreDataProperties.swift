//
//  CaloriesLeft+CoreDataProperties.swift
//  
//
//  Created by Daniel Salas on 11/14/21.
//
//

import Foundation
import CoreData
//This is our calories left entity By Default, the Number will be set to 2000, when the user adds more food
// it will be subtracted by how many calories the foood was

extension CaloriesLeft {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaloriesLeft> {
        return NSFetchRequest<CaloriesLeft>(entityName: "CaloriesLeft")
    }

    @NSManaged public var caloriesLeft: Double

}
