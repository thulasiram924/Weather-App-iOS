//
//  AddWeatherViewModel.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 26/11/24.
//

import Foundation

class AddWeatherViewModel {
    
    func addWeather(city: String, completion: @escaping (WeatherViewModel) -> Void){
        let url = Constants.urls.urlForWeatherByCity(city: city)
        let resourse = Resource(url: url) { data in
            return try? JSONDecoder().decode(WeatherResponse.self, from: data)
        }
        
        let webservice = Webservice()
        webservice.load(resource: resourse) { data in
            print(data?.list[0])
            
            if let data {
                let vm = WeatherViewModel(weather: data)
                completion(vm)
            }
           
        }
    }
}
