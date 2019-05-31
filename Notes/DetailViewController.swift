//
//  DetailViewController.swift
//  Notes
//
//  Created by Sasha on 23/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

protocol State {
    var isEditable: Bool { get }
    var isEmpty: Bool { get }
    var nameButton: String { get }
    func butonClicked()
}

class DetailViewController: UIViewController {
    
    var stateView: State!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var textField: UITextView!
    
    var simpleMark: Note?
    var button = UIBarButtonItem(title: "Button", style: .plain, target: self, action: #selector(buttonClicked))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
        setupNavigation()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    func configuration(simpleMark: Note? = nil, with state: State) {
        self.stateView = state
        self.simpleMark = simpleMark
    }
    
    
    func setupNavigation() {
        button.title = stateView.nameButton
        textField.isEditable = stateView.isEditable
        if !stateView.isEmpty {
            textField.text = simpleMark?.text
        }
        navigationItem.setRightBarButton(button, animated: false)
    }
    
    @objc func buttonClicked() {
        stateView.butonClicked()
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
