//
//  Favorites+CoreDataProperties.swift
//  News
//
//  Created by Jianfang Li on 3/25/19.
//  Copyright © 2019 Jianfang Li. All rights reserved.
//
//

import Foundation
import CoreData

extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var title: String?
    @NSManaged public var url: String?
}
