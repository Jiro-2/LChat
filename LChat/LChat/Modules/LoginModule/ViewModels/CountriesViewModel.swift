//
//  CountrySelectorViewModel.swift
//  LingoChat
//
//  Created by Егор on 27.01.2021.
//

import Foundation


protocol CountriesViewModelProtocol {
    
    var alphabet: [Character] { get }
    func getISOCodes() -> [String]
    func getCountries() -> [Character:[Country]]
}



class CountriesViewModel: CountriesViewModelProtocol {
    
    
    var navigator: LoginNavigator?
    var countrySelector: CountrySelectable
    var alphabet: [Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    
    init(countrySelector: CountrySelectable) {
        self.countrySelector = countrySelector
    }
    
    
    
    func getISOCodes() -> [String] {
        
        countrySelector.getCountryCodes()
    }
    
    
    func getCountries() -> [Character : [Country]] {
        
        var returnCountries = [Character : [Country]]()
        let countries = countrySelector.getAllCountries()
        
        for char in alphabet {
            
            var countriesWithSameFirstLeter = [Country]()
            
            for country in countries {

                if char == country.name?.first {
                    
                    countriesWithSameFirstLeter.append(country)
                }
            }
            
            returnCountries[char] = countriesWithSameFirstLeter
        }
                
        return returnCountries
    }
}
