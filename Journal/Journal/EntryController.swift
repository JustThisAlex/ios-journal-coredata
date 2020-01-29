//
//  EntryController.swift
//  Journal
//
//  Created by Alexander Supe on 27.01.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
//    var entries: [Entry] { loadFromPersistentStore() }
    
    static func saveToPersistentStore() {
        do { try CoreDataStack.shared.mainContext.save() }
        catch { NSLog("Error saving managed object context: \(error)") }
    }
    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        do {
//            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching tasks: \(error)")
//            return []
//        }
//    }
    
    //CRUD-methods
    func create(title: String, bodyText: String, mood: String) {
        Entry(title: title, bodyText: bodyText, mood: mood, context: CoreDataStack.shared.mainContext)
        EntryController.saveToPersistentStore()
    }
    
    func update(_ entry: Entry, title: String, bodyText: String, mood: String) {
        entry.title = title
        entry.bodyText = bodyText
        entry.mood = mood
        entry.timestamp = Date()
        EntryController.saveToPersistentStore()
    }
    
    func delete(_ entry: Entry) {
        CoreDataStack.shared.mainContext.delete(entry)
        EntryController.saveToPersistentStore()
    }
}
