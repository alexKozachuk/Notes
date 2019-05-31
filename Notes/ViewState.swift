//
//  ViewState.swift
//  Notes
//
//  Created by Sasha on 31/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class ViewState: State {
    
    private weak var view: DetailViewController?
    
    init(_ view: DetailViewController) {
        self.view = view
    }
    
    func setup() {
        view?.textField.isEditable = false
        view?.textField.text = view?.simpleMark?.text ?? ""
        view?.navigationItem.rightBarButtonItem = view?.shareButton
    }
    
    func butonClicked() {
        if let simpleMark = view?.simpleMark {
            let vc = UIActivityViewController(activityItems: [simpleMark.text], applicationActivities: [])
            view?.present(vc, animated: true)
        }
    }
    
}




