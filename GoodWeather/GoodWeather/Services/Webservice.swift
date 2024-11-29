//
//  Webservice.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 26/11/24.
//

import Foundation

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

final class Webservice{
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> Void){
        
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            
            if let data = data{
                DispatchQueue.main.async {
                    completion(resource.parse(data))
                }
            }else{
                completion(nil)
            }
        }.resume()
        
    }
    
    func getTemperatureForCity(url: URL, completion: @escaping (Double?) -> Void){
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data{
                let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(weatherResponse?.list.first?.main.temp)
            }else{
                completion(nil)
            }
        }.resume()
    }
    
}
