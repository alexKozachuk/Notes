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

    let isEmpty: Bool = false
    let isEditable: Bool = false
    let nameButton: String = "Share"
    
    init(_ view: DetailViewController) {
        self.view = view
    }
    
    func butonClicked() {
        if let simpleMark = view?.simpleMark {
            let vc = UIActivityViewController(activityItems: [simpleMark.text], applicationActivities: [])
            view?.present(vc, animated: true)
        }
    }
}




