import Foundation

extension String {
    

    var localized: String {
                
        let language = LanguageManager.shared.currentLang ?? "en"
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
   
    
    
    var isValidPhone: Bool {
        
        let phonePattern = "[0-9]{3}[ -]?[0-9]{3}[ -]?[0-9]{4}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", phonePattern)
        
        return predicate.evaluate(with: self)
    }
    
    
    
    func removingWhitespaces() -> String {
        
        return components(separatedBy: .whitespaces).joined()
    }
}

