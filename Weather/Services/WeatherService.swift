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
        
    // метод для загрузки данных, в качестве аргументов получает город
    func loadWeatherData(city: String){
            
    // путь для получения погоды за 5 дней
            let path = "/data/2.5/forecast"
    // параметры, город, единицы измерения (градусы), ключ для доступа к сервису
            let parameters: Parameters = [
                "q": city,
                "units": "metric",
                "appid": apiKey
            ]
            
    // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
            let url = baseUrl+path
            
    // делаем запрос
            AF.request(url, method: .get, parameters: parameters).responseData { [weak self] repsonse in
                guard let data = repsonse.value else { return }
                let weather = try! JSONDecoder().decode(WeatherResponse.self, from: data).list
                weather.forEach { $0.city = city }
                
                self?.saveWeatherData(weather, city: city)
            }
            
        }


    
    // сохранение погодных данных в realm
    func saveWeatherData(_ weathers: [Weather], city: String) {
    // обработка исключений при работе с хранилищем
            do {
    // получаем доступ к хранилищу
                let realm = try Realm()
    // получаем город
                guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
    // все старые погодные данные для текущего города
                let oldWeathers = city.weathers
    // начинаем изменять хранилище
                realm.beginWrite()
    // удаляем старые данные
                realm.delete(oldWeathers)
    // кладем все объекты класса погоды в хранилище
                city.weathers.append(objectsIn: weathers)
    // завершаем изменение хранилища
                try realm.commitWrite()
            } catch {
    // если произошла ошибка, выводим ее в консоль
                print(error)
            }
        }




}
