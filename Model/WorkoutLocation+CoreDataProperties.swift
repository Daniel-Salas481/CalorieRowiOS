//
//  WorkoutLocation+CoreDataProperties.swift
//  
//
//  Created by Daniel Salas on 11/14/21.
//
//

import Foundation
import CoreData


extension WorkoutLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutLocation> {
        return NSFetchRequest<WorkoutLocation>(entityName: "WorkoutLocation")
    }

    @NSManaged public var address: String?

}
