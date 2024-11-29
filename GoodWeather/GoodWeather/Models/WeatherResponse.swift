//
//  WeatherResponse.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 26/11/24.
//

import Foundation



struct WeatherResponse: Codable{
    let list: [Main]
    let city: City
}

struct City: Codable{
    let name: String
}

struct Main: Codable{
    let main: Weather
}

struct Weather: Codable{
    let temp: Double
    let humidity: Double
}
