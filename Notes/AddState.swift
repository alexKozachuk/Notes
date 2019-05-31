//
//  AddState.swift
//  Notes
//
//  Created by Sasha on 31/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class AddState: State {
    
    private weak var view: DetailViewController?
    
    let isEmpty: Bool = true
    let isEditable: Bool = true
    let nameButton: String = "Save"
    
    init(_ view: DetailViewController) {
        self.view = view
    }
    
    func butonClicked() {
        
        let text = view?.textField.text ?? ""
        let simpleMark = Note(text: text, date: Date())
        RealmService.shared.create(simpleMark)
        
        view?.navigationController!.popViewController(animated: true)
    }
}
