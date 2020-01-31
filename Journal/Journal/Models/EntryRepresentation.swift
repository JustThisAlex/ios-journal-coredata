//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Alexander Supe on 31.01.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var timestamp: Date
    var identifier: String
    var mood: String
}
