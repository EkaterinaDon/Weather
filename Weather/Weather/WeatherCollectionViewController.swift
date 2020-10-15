//
//  WeatherCollectionViewController.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 09/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit
import Alamofire

class WeatherCollectionViewController: UIViewController {
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    @IBOutlet weak var dayPicker: WeekDayPicker!
    
    let weatherService = WeatherService()
    var weathers = [Weather]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // отправим запрос для получения погоды в Москве
        weatherService.loadWeatherData(city: "Moscow") { [weak self] weathers in
                // сохраняем полученные данные в массиве, чтобы коллекция могла получить к ним доступ
                    self?.weathers = weathers
                // коллекция должна прочитать новые данные
                    self?.weatherCollectionView?.reloadData()
                }
  
    }
    
}

extension WeatherCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        cell.configure(whith: weathers[indexPath.row])

        return cell
    }
    
    
}
