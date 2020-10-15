//
//  WeatherCollectionViewController.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 09/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class WeatherCollectionViewController: UIViewController {
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    @IBOutlet weak var dayPicker: WeekDayPicker!
    
    let weatherService = WeatherService()
    var weathers = [Weather]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // отправим запрос для получения погоды в Москве
        weatherService.loadWeatherData(city: "Moscow") { [weak self] in
                    
                    self?.loadData()
                    
                    self?.weatherCollectionView?.reloadData()
                }

  
    }
    
    func loadData() {
            do {
                let realm = try Realm()
                
                let weathers = realm.objects(Weather.self).filter("city == %@", "Moscow")
                
                self.weathers = Array(weathers)
                
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
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
