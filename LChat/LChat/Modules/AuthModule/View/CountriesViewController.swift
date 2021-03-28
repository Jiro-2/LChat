//
//  CountrySelectorViewController.swift
//  LingoChat
//
//  Created by Егор on 27.01.2021.
//

import UIKit

protocol CountriesViewControllerDelegate: class {
    
    func selectCountry(_ country: Country)
}


class CountriesViewController: UITableViewController {
    
    //MARK: - Properties -
    
    var viewModel: CountriesViewModelProtocol?
    weak var delegate: CountriesViewControllerDelegate?
    var countries: [Character:[Country]]?
    
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = viewModel?.getCountries()
        subscribeDelegate()
    }
    
    //MARK: - Methods -
    
    
    func subscribeDelegate() {
        
        
        if let previousVC = self.navigationController?.previousViewController() {
            
            if let loginVC = previousVC as? LoginViewController {
                
                delegate = loginVC
            }
            
            if let signupVC = previousVC as? SignUpViewController {
                
                delegate = signupVC
            }
        }
    }
    
    
   
    //MARK: - Table -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let key = viewModel?.alphabet[indexPath.section], let countries = countries?[key] {
            
            dismiss(animated: true) {
                
                    self.delegate?.selectCountry(countries[indexPath.row])
            }
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let key = viewModel?.alphabet[indexPath.section],
           let countries = self.countries?[key],
           let flag = countries[indexPath.row].flag,
           let name = countries[indexPath.row].name {
            
            cell.textLabel?.text = flag + " " + name
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 26
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var amountOfCountries: Int
        
        if let key = viewModel?.alphabet[section], let countries = countries {
            
            amountOfCountries = countries[key]?.count ?? 0
            
        } else {
            
            amountOfCountries = 0
        }
        
        return amountOfCountries
    }
    
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        viewModel?.alphabet.map() { "\($0)" }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let title = viewModel?.alphabet[section] else { return "Section" }
        
        return String(title).uppercased()
    }
}
