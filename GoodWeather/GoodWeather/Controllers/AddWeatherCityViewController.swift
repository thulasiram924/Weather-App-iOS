//
//  AddWeatherCityViewController.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 05/11/24.
//

import Foundation
import UIKit

protocol AddWeatherDelegate{
    func addWeatherDidSave(_ weatherViewModel: WeatherViewModel)
}

class AddWeatherCityViewController: UIViewController{
    
    //MARK: - Properties
    @IBOutlet weak var cityName: UITextField!
    var delegate: AddWeatherDelegate?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
    }
    
    func configureUI() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        appearance.backgroundColor = UIColor(displayP3Red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = "Add City"
    }
    
    
    //MARK: - Button Actions
    @IBAction func onSave(_ sender: Any) {
        debugPrint("save button clicked")
        
        if let cityNAme = cityName.text {
            
            let addWeatherVM = AddWeatherViewModel()
            addWeatherVM.addWeather(city: cityNAme) { weatherViewModel in
            
                self.delegate?.addWeatherDidSave(weatherViewModel)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
    }
    
    @IBAction func onClose(_ sender: Any) {
        debugPrint("close button clicked")
        self.dismiss(animated: true)
    }
    
}
