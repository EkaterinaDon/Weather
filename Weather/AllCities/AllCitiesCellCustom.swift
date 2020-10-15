//
//  AllCitiesCellCustom.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 27/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

//import Foundation
import UIKit

class AllCitiesCell: UITableViewCell {
    
    @IBOutlet var cityName: UILabel! {
        didSet {
            self.cityName.textColor = UIColor.yellow
        }
    }
    @IBOutlet var cityEmblemView: UIImageView! {
        didSet {
            self.cityEmblemView.layer.borderColor = UIColor.white.cgColor
            self.cityEmblemView.layer.borderWidth = 2
        }
    }
    
    func configure(city: String, emblem: UIImage) {
        self.cityName.text = city
        self.cityEmblemView.image = emblem
        
        self.backgroundColor = UIColor.black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cityName.text = nil
        self.cityEmblemView.image = nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        cityEmblemView.clipsToBounds = true
        cityEmblemView.layer.cornerRadius = cityEmblemView.frame.width / 2
    }
    
}
