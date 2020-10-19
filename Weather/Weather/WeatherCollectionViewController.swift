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
    var weathers: List<Weather>!
    var token: NotificationToken?
    let dateFormatter = DateFormatter()
    var cityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // отправим запрос для получения погоды в Москве
        weatherService.loadWeatherData(city: cityName)
        pairTableAndRealm()

  
    }
    
    
    func pairTableAndRealm() {
            guard let realm = try? Realm(), let city = realm.object(ofType: City.self, forPrimaryKey: cityName) else { return }
            
            weathers = city.weathers
            
            token = weathers.observe { [weak self] (changes: RealmCollectionChange) in
                guard let collectionView = self?.weatherCollectionView else { return }
                switch changes {
                case .initial:
                    collectionView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                        collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                        collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                    }, completion: nil)
                case .error(let error):
                    fatalError("\(error)")
                }
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
