//
//  String+Extensions.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 26/11/24.
//

import Foundation

extension String{
    
    func escaped() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
    
}
