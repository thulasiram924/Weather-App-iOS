//
//  Double+Extensions.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 26/11/24.
//

import Foundation

extension Double {
    
    func formatAsDegree() -> String {
        return String(format: "%.0f°", self)
    }
}
