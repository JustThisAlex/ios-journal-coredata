//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Alexander Supe on 27.01.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var entry: Entry? { didSet { updateViews() }}

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var time: UILabel!
    
    func updateViews() {
        guard let entry = entry else { return }
        title.text = entry.title
        body.text = entry.bodyText
        time.text = formatDate(entry.timestamp)
    }

    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: date)
    }

}
