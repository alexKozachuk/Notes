//
//  EditState.swift
//  Notes
//
//  Created by Sasha on 31/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import UIKit



class EditState: State {
    
    private weak var view: DetailViewController?
    private let nameButton: String = "Edit"
    var isEdit: Bool = false
    
    init(_ view: DetailViewController) {
        self.view = view
    }
    
    func setup() {
        view?.button.title = nameButton
        view?.textField.text = view?.simpleMark?.text ?? ""
        view?.textField.isEditable = false
        view?.navigationItem.rightBarButtonItem = view?.button
    }
    
    func butonClicked() {
        
        if isEdit {
            guard let text = view?.textField.text else { return }
            guard let simpleMark = view?.simpleMark else { return }
            let dict: [String: Any?] = ["text" : text,
                                        "date" : Date()]
            RealmService.shared.update(simpleMark, with: dict)
            
            view?.navigationController!.popViewController(animated: true)
        } else {
            view?.button.title = "Save"
            view?.textField.isEditable = true
            isEdit.toggle()
        }
    }
    
}
