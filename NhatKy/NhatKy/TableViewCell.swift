//
//  TableViewCell.swift
//  NhatKy
//
//  Created by Lê Hoàng Sinh on 6/21/20.
//  Copyright © 2020 Lê Hoàng Sinh. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblSoLuong: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
