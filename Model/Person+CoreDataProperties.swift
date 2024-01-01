//
//  Person+CoreDataProperties.swift
//  CalorieRow
//
//  Created by Daniel Salas on 11/10/21.
//
//

import Foundation
import CoreData

//DO NOT MODIFY
extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var birthday: String?
    @NSManaged public var weight: Int64

}

extension Person : Identifiable {

}
