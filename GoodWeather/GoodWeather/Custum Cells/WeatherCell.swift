//
//  WeatherCell.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 18/11/24.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    func configure(viewModel: WeatherViewModel){
        
        self.cityName.text = viewModel.weather.city.name
        self.temperature.text = "\(viewModel.temperature.formatAsDegree())"
        
    }
    
}
