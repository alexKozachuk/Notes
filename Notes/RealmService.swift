//
//  RealmService.swift
//  Notes
//
//  Created by Sasha on 23/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class RealmService {

    private init() {
        do {
            realm = try Realm()
        } catch let error as NSError {
            fatalError("Realm does not work")
        }
    }
    
    static let shared = RealmService()

    var isEdit: Bool = false
    var realm: Realm

    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
                isEdit = true
            }
        } catch {
            post(error)
        }
    }

    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
                isEdit = false
            }
        } catch {
            post(error)
        }
    }

    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
                isEdit = true
            }
        } catch {
            post(error)
        }
    }

    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }

    func observeRealmErrors(in vc: UIViewController, competition: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("RealmError"),
                                               object: nil,
                                               queue: nil) { (notification) in
                                                competition(notification.object as? Error)
        }
    }

    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: Notification.Name("RealmError"), object: nil)
    }
}
