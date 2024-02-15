//
//  TableViewCellfeed.swift
//  SnapchatClone
//
//  Created by Mehmet Emin Fırıncı on 15.02.2024.
//

import UIKit

class TableViewCellfeed: UITableViewCell {
    @IBOutlet var imagefeed: UIImageView!
    @IBOutlet var usernamefeed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
