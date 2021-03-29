//
//  DataModel+CoreDataProperties.swift
//  Yand
//
//  Created by Mac on 19.03.2021.
//
//

import Foundation
import CoreData


extension DataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataModel> {
        return NSFetchRequest<DataModel>(entityName: "DataModel")
    }

    @NSManaged public var symbol: String?

}

extension DataModel : Identifiable {

}
