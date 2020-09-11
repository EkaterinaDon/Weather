//
//  WeatherCollectionViewController.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 09/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit

class WeatherCollectionViewController: UIViewController {
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    @IBOutlet weak var dayPicker: WeekDayPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension WeatherCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        //cell.backgroundColor = .lightGray
        cell.weather.text = "30 C"
        cell.time.text = "03.08.2020 15:30"
        // Configure the cell
        
        return cell
    }
    
    
}
