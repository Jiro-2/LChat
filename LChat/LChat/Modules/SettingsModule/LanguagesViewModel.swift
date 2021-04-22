//
//  LanguagesViewModel.swift
//  LChat
//
//  Created by Егор on 18.04.2021.
//

import Foundation

protocol LanguagesViewModelProtocol {
    
    var languages: [String] { get }
    var currentLang: String? { get }
    
    func set( _ language: String)
}


final class LanguagesViewModel: LanguagesViewModelProtocol {
    
    var languages = LanguageManager.shared.availableLanguages
    var currentLang = LanguageManager.shared.currentLang
   
    init() {
        
        moveToStartCurrentLang()
    }
    
   
    func set(_ language: String) {
        
        if let currentLang = currentLang {
            
            if language != currentLang {
            
                LanguageManager.shared.currentLang = language
            }
        }
    }
    
    
    private func moveToStartCurrentLang() {
        
        guard let indexCurrentLang = languages.firstIndex(of: currentLang!) else { return }
        
        if indexCurrentLang == 0 {
            
            return
            
        } else {
            
            languages.remove(at: indexCurrentLang)
            languages.insert(currentLang!, at: 0)
        }
    }
}
