//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Alexander Supe on 27.01.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? { didSet { updateViews() }}
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        guard let title = textField.text, let bodyText = textView.text else { return }
        if let entry = entry { EntriesTableViewController.entryController.update(entry, title: title, bodyText: bodyText); dismiss(animated: true, completion: nil)}
        else { EntriesTableViewController.entryController.create(title: title, bodyText: bodyText); navigationController?.dismiss(animated: true, completion: nil)}
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
