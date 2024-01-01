//
//  CalorieIntake+CoreDataProperties.swift
//  
//
//  Created by Daniel Salas on 11/14/21.
//
//

import Foundation
import CoreData


extension CalorieIntake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalorieIntake> {
        return NSFetchRequest<CalorieIntake>(entityName: "CalorieIntake")
    }

    @NSManaged public var calorieIntake: Double

}
