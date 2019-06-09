//
//  TableViewCell.swift
//  Notes
//
//  Created by Sasha on 23/05/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var timeField: UILabel!
    @IBOutlet weak var markField: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(with note: Note) {
        dateField.text = note.getFormatDate
        timeField.text = note.getFormatTime
        markField.text = note.text
    }

}
