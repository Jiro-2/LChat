import Foundation

protocol LanguagesViewModelProtocol {
    
    var languages: [String] { get }
    var currentLang: String? { get }
    
    func set( _ language: String)
}


final class LanguagesViewModel: LanguagesViewModelProtocol {
    
    //MARK: - Properties -
    
    var languages = LanguageManager.shared.availableLanguages
    var currentLang = LanguageManager.shared.currentLang
   
    
    //MARK: - Init -
    
    init() {
        
        checkDefaultLang()
        moveToStartCurrentLang()
    }
    
    
    
    //MARK: - Methods -
   
    func set(_ language: String) {
        
        if let currentLang = currentLang {
            
            if language != currentLang {
            
                LanguageManager.shared.currentLang = language
            }
        }
    }
    
    
    
    private func checkDefaultLang() {
        
        if currentLang == nil {
            
            LanguageManager.shared.currentLang = "en"
        }
    }
    
    
    
    private func moveToStartCurrentLang() {
        
        guard let lang = currentLang,
              let indexCurrentLang = languages.firstIndex(of: lang) else { assertionFailure(); return }
        
        if indexCurrentLang == 0 {
            
            return
            
        } else {
            
            languages.remove(at: indexCurrentLang)
            languages.insert(currentLang!, at: 0)
        }
    }
}
