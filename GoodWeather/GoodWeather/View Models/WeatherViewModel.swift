//
//  WeatherViewModel.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 26/11/24.
//

import Foundation

class WeatherListViewModel {
    
    private var weatherViewModels = [WeatherViewModel]()
    private var webService = Webservice()
    
    init() {
        weatherViewModels = retrieveWeatherViewModels()
    }
    
    func addWeatherViewModel(vm :WeatherViewModel){
        weatherViewModels.append(vm)
    }
    func deleteWeatherViewModel(at index: Int){
        weatherViewModels.remove(at: index)
    }
    
    func numberOfRows(_ section: Int) -> Int{
        weatherViewModels.count
    }
    
    func modelAt(_ index: Int) -> WeatherViewModel{
        weatherViewModels[index]
    }
    
    func toCelsius(){
        weatherViewModels = weatherViewModels.map{ vm in
            let weatherModel = vm
            weatherModel.temperature = (weatherModel.temperature - 32) * 5/9
            return weatherModel
        }
    }
    
    func toFahrenheit(){
        weatherViewModels = weatherViewModels.map{ vm in
            let weatherModel = vm
            weatherModel.temperature = (weatherModel.temperature * 9/5) + 32
            return weatherModel
        }
    }
    
    func updateUnit(to unit: Unit){
        switch unit{
            case .celsius:
                toCelsius()
            case .fahrenheit:
                toFahrenheit()
        }
    }
    
    func saveWeatherViewModels(){
        let fileManager = FileManager.default
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("weather.json")
        
        do{
            let data = try JSONEncoder().encode(weatherViewModels)
            try data.write(to: fileURL)
        }catch{
            
        }
    }
    
    func retrieveWeatherViewModels() -> [WeatherViewModel]{
        let fileManager = FileManager.default
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("weather.json")
        
        do{
            let data = try Data(contentsOf: fileURL)
            let weatherResponses = try? JSONDecoder().decode([WeatherViewModel].self, from: data)
            print(weatherResponses!)
            self.weatherViewModels = weatherResponses!
        }catch{
            
        }
        return weatherViewModels
    }
    
    func updateTemperatures(completion: @escaping () -> Void) {
        var weatherModelsCount = 0
        for weatherModel in weatherViewModels{
            let url = Constants.urls.urlForWeatherByCity(city: weatherModel.city)
            webService.getTemperatureForCity(url: url, completion: { temp in
                if let temp {
                    weatherModel.temperature = temp
                }
                weatherModelsCount += 1
                if weatherModelsCount == self.weatherViewModels.count{
                    DispatchQueue.main.async{
                        completion()
                    }
                }
            })
        }
    }

}

class WeatherViewModel: Codable {
    
    let weather: WeatherResponse
    var temperature: Double
    
    init(weather: WeatherResponse){
        self.weather = weather
        self.temperature = weather.list.first?.main.temp ?? 99999999
    }
    
    var city: String {
        return weather.city.name
    }
    
    enum codingKeys: String, CodingKey {
        case weather = "weather"
        case temperature
        case city
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.weather, forKey: .weather)
        try container.encode(self.temperature, forKey: .temperature)
    }
}
