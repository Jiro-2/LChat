
import Foundation

final class LanguageManager {
    
    
    //MARK: - Properties -
    
    static let shared = LanguageManager()
    
    lazy var didChangeLangBlocks = [(() -> ())]()
    lazy var availableLanguages = ["en", "ru"]
    
    var currentLang: String? {
        
        get {
            
            UserDefaults.standard.string(forKey: "app_lang")
        }
        
        set {
            
            UserDefaults.standard.setValue(newValue, forKey: "app_lang")
            
            self.didChangeLangBlocks.forEach { block in
                
                block()
            }
        }
    }
}
