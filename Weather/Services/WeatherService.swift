//
//  WeatherService.swift
//  Weather
//
//  Created by Ekaterina Donskaya on 26/09/2020.
//  Copyright © 2020 Ekaterina Donskaya. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class WeatherService {
    
    // базовый URL сервиса
        let baseUrl = "http://api.openweathermap.org"
        // ключ для доступа к сервису
        let apiKey = "92cabe9523da26194b02974bfcd50b7e"
        
            func loadWeatherData(city: String, completion: @escaping ([Weather]) -> Void ) {
                    
                    // путь для получения погоды за 5 дней
                    let path = "/data/2.5/forecast"
                    // параметры, город, единицы измерения градусы, ключ для доступа к сервису
                    let parameters: Parameters = [
                        "q": city,
                        "units": "metric",
                        "appid": apiKey
                    ]
                    
                    // составляем url из базового адреса сервиса и конкретного пути к ресурсу
                    let url = baseUrl+path
                // делаем запрос
//                        AF.request(url, method: .get, parameters: parameters).responseData { response in
//                            guard let data = response.value else { return }
//                      let weather = try! JSONDecoder().decode(WeatherResponse.self, from: data).list
//
//                            completion(weather)
//                        }
                AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
                            guard let data = response.value else { return }

                            let weather = try! JSONDecoder().decode(WeatherResponse.self, from: data).list
                            
                            self?.saveWeatherData(weather)
                            
                            completion(weather)
                        }

                
                    }
    
    //сохранение погодных данных в Realm
        func saveWeatherData(_ weathers: [Weather]) {
    // обработка исключений при работе с хранилищем
            do {
    // получаем доступ к хранилищу
                let realm = try Realm()
                
    // начинаем изменять хранилище
                realm.beginWrite()
                
    // кладем все объекты класса погоды в хранилище
                realm.add(weathers)
                
    // завершаем изменения хранилища
                try realm.commitWrite()
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }


}
