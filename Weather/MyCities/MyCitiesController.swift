//
//  MyCitiesController.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 03/08/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import UIKit

class MyCitiesController: UITableViewController {
    
    var cities = [String]()
    
    @IBAction func addCity(segue: UIStoryboardSegue) {
        
        //проверяем идентификатор, чтобы убедиться что это нужный переход
        if segue.identifier == "addCity" {
            
            //получаем ссылку на контроллер, с которого осуществлен переход
            guard let allCitiesController = segue.source as? AllCitiesController else { return }
            
            //получаем индекс выделенной ячейки
            if let indexPath = allCitiesController.tableView.indexPathForSelectedRow {
                //получаем город по индексу
                let city = allCitiesController.cities[indexPath.row]
                //проверяем что города нет в списке
                if !cities.contains(city) {
                    //добавляем город в список выбранных
                    cities.append(city)
                    //обновляем таблицу
                    tableView.reloadData()
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //получаем ячейку из пула
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCitiesCell", for: indexPath) as! MyCitiesCell
        
        //получаем город для строки
        let city = cities[indexPath.row]
        
        // устанавливаем город в надпись ячейки
        cell.myCityName.text = city // в методичке cell.cityName = city
        
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
        //если нажали Удалить
        if editingStyle == .delete {
            //удаляем город из массива
            cities.remove(at: indexPath.row)
            // Delete the row from table
            tableView.deleteRows(at: [indexPath], with: .fade)
            
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
