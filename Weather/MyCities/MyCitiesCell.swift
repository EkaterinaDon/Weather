//
//  MyCitiesCell.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 03/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit

class MyCitiesCell: UITableViewCell {

    @IBOutlet weak var myCityName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
