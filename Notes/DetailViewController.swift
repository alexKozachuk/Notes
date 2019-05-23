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
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var textField: UITextView!
    
    var state: WorkState = .view
    var simpleMark: Note?
    
    var saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addItem))
    var editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItem))
    var shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareItem))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    func setupState() {
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
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                let height = endFrame?.size.height ?? 0.0
                self.keyboardHeightLayoutConstraint?.constant = height - 40
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

}
