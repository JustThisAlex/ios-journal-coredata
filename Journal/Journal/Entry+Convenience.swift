//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Alexander Supe on 27.01.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    @discardableResult
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = String(Int.random(in: 1000...1000000000)), mood: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood
    }
}
