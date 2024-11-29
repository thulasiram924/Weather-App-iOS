//
//  SettingsViewModel.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 27/11/24.
//

import Foundation

enum Unit: String, CaseIterable{
    case celsius = "metric"
    case fahrenheit = "imperial"
}

extension Unit{
    var displayName: String{
        get{
            switch(self){
            case .celsius:
                return "Celsius"
            case .fahrenheit:
                return "Fahrenheit"
            }
        }
    }
}

class SettingsViewModel{
    
    var units = Unit.allCases
    
    var selectedUnit: Unit{
        get{
            let userDefaults = UserDefaults.standard
            var unitValue = Unit.allCases.first?.rawValue ?? ""
            if let value = userDefaults.value(forKey: "unit") as? String{
                unitValue = value
            }
            return Unit(rawValue: unitValue)!
        }
        set{
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue.rawValue, forKey: "unit")
        }
    }
    
}
