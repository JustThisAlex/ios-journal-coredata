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
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title, let bodyText = bodyText, let timestamp = timestamp, let identifier = identifier, let mood = mood else { return nil }
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier.uuidString, mood: mood)
    }
    
    @discardableResult
    convenience init(title: String, bodyText: String, timestamp: Date = Date(), identifier: UUID = UUID(), mood: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context); self.title = title; self.bodyText = bodyText; self.timestamp = timestamp; self.identifier = identifier; self.mood = mood
    }
    
    @discardableResult
    convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifier = UUID(uuidString: entryRepresentation.identifier) else { return nil }
        self.init(title: entryRepresentation.title, bodyText: entryRepresentation.bodyText, timestamp: entryRepresentation.timestamp, identifier: identifier, mood: entryRepresentation.mood, context: context)
    }
}
