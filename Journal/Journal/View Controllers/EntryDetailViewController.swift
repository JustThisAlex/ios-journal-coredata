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
    var entryController: EntryController?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var moodSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViews()
        updateViews()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let title = textField.text, let bodyText = textView.text, let mood = moodSegment.titleForSegment(at: moodSegment.selectedSegmentIndex), let entryController = entryController else { return }
        if let entry = entry { entryController.update(entry, title: title, bodyText: bodyText, mood: mood); dismiss(animated: true, completion: nil)}
        else { entryController.create(entry: Entry(title: title, bodyText: bodyText, mood: mood)); dismissme()}
    }
    
    private func formatViews() {
        textField.layer.cornerRadius = 7.5
        textView.layer.cornerRadius = 7.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        textField.leftViewMode = .always
        if entry == nil { navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissme)) }
    }
    
    @objc func dismissme() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        title = entry?.title ?? "Create Entry"
        textField.text = entry?.title
        textView.text = entry?.bodyText
        moodSegment.selectedSegmentIndex = {
            if entry?.mood == moodSegment.titleForSegment(at: 0) { return 0 }
            else if entry?.mood == moodSegment.titleForSegment(at: 1) { return 1 }
            else if entry?.mood == moodSegment.titleForSegment(at: 2) { return 2 }
            else { return 1 }
        }()
    }
    
}
