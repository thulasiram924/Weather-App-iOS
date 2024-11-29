//
//  WeatherListTableViewController.swift
//  GoodWeather
//
//  Created by Thulasi Ram on 05/11/24.
//

import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController, AddWeatherDelegate, SettingsDelegate{
    
    private var weatherListViewModel = WeatherListViewModel()
    var unitSelected: Unit!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        if let unit = userDefaults.value(forKey: "unit") as? String {
            unitSelected = Unit(rawValue: unit)
        }
        
        configureUI()
        startFrequentTemperatureUpdates()
    }
    
    func updateTemperatures() {
        self.weatherListViewModel.updateTemperatures {
            self.weatherListViewModel.saveWeatherViewModels()
            self.tableView.reloadData()
            print("Temperatures are updated")
        }
    }
    
    func startFrequentTemperatureUpdates() {
        updateTemperatures()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { (_) in
            self.updateTemperatures()
        }
        
    }
    
    func configureUI() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(displayP3Red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    //MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        let vm = weatherListViewModel.modelAt(indexPath.row)
        cell.configure(viewModel: vm)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Last updated on: \(Date().formatted(date: .numeric, time: .standard))"
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherListViewModel.deleteWeatherViewModel(at: indexPath.row)
            weatherListViewModel.saveWeatherViewModels()
            tableView.reloadData()
        }
    }
    //MARK: - AddWeatherDelegate
    func addWeatherDidSave(_ weatherViewModel: WeatherViewModel) {
        weatherListViewModel.addWeatherViewModel(vm: weatherViewModel)
        weatherListViewModel.saveWeatherViewModels()
        tableView.reloadData()
    }
    
    //MARK: - SettingsDelegate
    func settingsDone(_ vm: SettingsViewModel) {
        if unitSelected.rawValue != vm.selectedUnit.rawValue {
            weatherListViewModel.updateUnit(to: vm.selectedUnit)
            weatherListViewModel.saveWeatherViewModels()
            tableView.reloadData()
            unitSelected = Unit(rawValue:vm.selectedUnit.rawValue)
        }
        
    }
        
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddWeatherCityViewController" {
            prepareSegueForAddWeatherCityViewController(segue: segue)
        }else if segue.identifier == "SettingsViewController"{
            prepareSegueForSettingsViewController(segue: segue)
        }
        
    }
    
    func prepareSegueForAddWeatherCityViewController(segue : UIStoryboardSegue){
        
        guard let nav = segue.destination as? UINavigationController else{
            fatalError("NavigationController not found")
        }
        guard let addWeatherCityViewController = nav.viewControllers.first as? AddWeatherCityViewController else{
            fatalError("AddWeatherCityViewController not found")
        }
    
        addWeatherCityViewController.delegate = self
    }
    
    func prepareSegueForSettingsViewController(segue : UIStoryboardSegue){
        
        guard let nav = segue.destination as? UINavigationController else{
            fatalError("NavigationController not found")
        }
        guard let settingsTableViewController = nav.viewControllers.first as? SettingsTableViewController else{
            fatalError("SettingsViewController not found")
        }
        
        settingsTableViewController.delegate = self
    }
    
    deinit{
        print("Deinitializing WeatherListTableViewController")
        weatherListViewModel.saveWeatherViewModels()
    }
    
}

