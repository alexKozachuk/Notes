//
//  Note.swift
//  Notes
//
//  Created by Sasha on 23/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Note: Object {
    dynamic var text: String = ""
    dynamic var date: Date = Date()
    
    convenience init(text: String, date: Date) {
        self.init()
        self.text = text
        self.date = date
    }
    
    var getFormatDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let myString = formatter.string(from: self.date)
        
        return  myString
    }
    
    var getFormatTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let myString = formatter.string(from: self.date)
        
        return  myString
    }
}
