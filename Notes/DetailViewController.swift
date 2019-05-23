//
//  DetailViewController.swift
//  Notes
//
//  Created by Sasha on 23/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    enum WorkState {
        case view, edit, add
    }
    
    @IBOutlet weak var textField: UITextView!
    
    var state: WorkState = .view
    var simpleMark: Note?
    
    var saveButton = UIBarButtonItem(title: "Cохранить", style: .done, target: self, action: #selector(addItem))
    var editButton = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editItem))
    var shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareItem))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.state {
        case .add:
            navigationItem.setRightBarButton(saveButton, animated: false)
        case .edit:
            textField.isEditable = false
            navigationItem.setRightBarButton(editButton, animated: false)
            textField.text = simpleMark?.text
        case .view:
            textField.isEditable = false
            navigationItem.setRightBarButton(shareButton, animated: false)
            textField.text = simpleMark?.text
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    func configuration(simpleMark: Note? = nil, with state: WorkState) {
        self.state = state
        self.simpleMark = simpleMark
    }
    
    @objc func addItem() {
        let text = textField.text ?? ""
        
        
        if state == .add {
            let simpleMark = Note(text: text, date: Date())
            RealmService.shared.create(simpleMark)
        } else {
            let dict: [String: Any?] = ["text" : text,
                                        "date" : Date()]
            guard let simpleMark = simpleMark else { return }
            RealmService.shared.update(simpleMark, with: dict)
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    @objc func editItem() {
        navigationItem.setRightBarButton(saveButton, animated: true)
        textField.isEditable = true
    }
    
    @objc func shareItem() {
        if let simpleMark = simpleMark {
            let vc = UIActivityViewController(activityItems: [simpleMark.text], applicationActivities: [])
            present(vc, animated: true)
        }
    }
    
}
