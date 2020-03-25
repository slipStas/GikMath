//
//  Math+CoreDataProperties.swift
//  GikMath
//
//  Created by Stanislav Slipchenko on 25.03.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Math {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Math> {
        return NSFetchRequest<Math>(entityName: "Math")
    }

    @NSManaged public var math: String?
    @NSManaged public var id: Int64

}
