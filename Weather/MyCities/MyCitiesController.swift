//
//  MyCitiesController.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 03/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit
import RealmSwift

class MyCitiesController: UITableViewController {
    
    var weatherService = WeatherService()
    var cityes: Results<City>?
    var token: NotificationToken?
    
    @IBAction func addButtonPressed(_ sender: Any) {
            showAddCityForm()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //weatherService.loadWeatherData(city: "Moscow")
        pairTableAndRealm()

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityes!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCitiesCell", for: indexPath) as! MyCitiesCell
        
        //получаем город для строки
        let city = cityes![indexPath.row]
        
        // устанавливаем город в надпись ячейки
        cell.myCityName.text = city.name
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let city = cityes![indexPath.row]
                if editingStyle == .delete {
                    do {
                        let realm = try Realm()
                        realm.beginWrite()
                        realm.delete(city.weathers)
                        realm.delete(city)
                        try realm.commitWrite()
                    } catch {
                        print(error)
                    }
                }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherViewController", let cell = sender as? UITableViewCell {
                let ctrl = segue.destination as! WeatherCollectionViewController
                if let indexPath = tableView.indexPath(for: cell) {
                    ctrl.cityName = cityes![indexPath.row].name
                }
            }
        }

    
    
    func pairTableAndRealm() {
            guard let realm = try? Realm() else { return }
            cityes = realm.objects(City.self)
        token = cityes!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        }

    
    func showAddCityForm() {
            let alertController = UIAlertController(title: "Введите город", message: nil, preferredStyle: .alert)
            alertController.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            })
        let confirmAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] action in
                guard let name = alertController.textFields?[0].text else { return }
                self?.addCity(name: name)
            }
            alertController.addAction(confirmAction)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: {  })
        }

    func addCity(name: String) {
            let newCity = City()
            newCity.name = name
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(newCity, update: .all)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }

    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
