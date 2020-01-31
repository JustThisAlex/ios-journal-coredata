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
    let baseURL = URL(string: "https://journal-207d3.firebaseio.com/")!
    typealias CompletionHandler = (Error?) -> Void
    
    init() { read() }
    
    // MARK: - CRUD methods
    func create(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = entry.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = entry.entryRepresentation else { completion(NSError()); return }
            representation.identifier = uuid.uuidString
            entry.identifier = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding entry \(entry): \(error)")
            DispatchQueue.main.async { completion(error) }
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error PUTting entry to server: \(error)")
                DispatchQueue.main.async { completion(error) }
                return
            }
            DispatchQueue.main.async { completion(nil) }
        }.resume()
    }
    
    func read(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                print("Error fetching entries: \(error)")
                DispatchQueue.main.async { completion(error) }
                return
            }
            
            guard let data = data else {
                print("No data return by data entry")
                DispatchQueue.main.async { completion(NSError()) }
                return
            }
            
            do {
                let entryRepresentations = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.update(with: entryRepresentations)
                DispatchQueue.main.async { completion(nil) }
            } catch {
                print("Error decoding or storing entry representations: \(error)")
                DispatchQueue.main.async { completion(error) }
            }
        }.resume()
    }
    
    func update(_ entry: Entry, title: String, bodyText: String, mood: String) {
        delete(entry)
        CoreDataStack.shared.mainContext.delete(entry)
        do {
            try CoreDataStack.shared.mainContext.save()
        }
        catch {
            CoreDataStack.shared.mainContext.reset()
            NSLog("Error saving managed object context: \(error)")
        }
        create(entry: Entry(title: title, bodyText: bodyText, mood: mood))
    }
    
    func delete(_ entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else { completion(NSError()); return }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            print(response!)
            DispatchQueue.main.async { completion(error) }
        }.resume()
    }
    
    // MARK: - Internal methods
    private func update(with representations: [EntryRepresentation]) throws {
        guard representations.isEmpty == false else { return }
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let existingEntries = try context.fetch(fetchRequest)
                for entry in existingEntries {
                    guard let id = entry.identifier,
                        let representation = representationsByID[id] else { continue }
                    self.updateData(entry: entry, with: representation)
                    entriesToCreate.removeValue(forKey: id)
                }
                for representation in entriesToCreate.values { Entry(entryRepresentation: representation, context: context) }
            }
            catch { print("Error fetching entries for UUIDs: \(error)") }
        }
        try CoreDataStack.shared.save(context: context)
    }
    
    private func updateData(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }
}
