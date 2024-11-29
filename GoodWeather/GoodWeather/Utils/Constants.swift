//
//  Constants.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 26/11/24.
//

import Foundation

struct Constants {
    struct urls{
        static func urlForWeatherByCity(city: String) -> URL{
            
            let userDefaults = UserDefaults.standard
            let unit = userDefaults.value(forKey: "unit") as? String ?? "imperial"
            return URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city.escaped())&appid=68ba122be59e44b22b879bcb5c505073&units=\(unit)")!
        }
        
    }
}
