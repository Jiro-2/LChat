import class UIKit.UIColor
import Foundation

protocol ThemeObserver: class {
    
    func didChangePrimaryColor(_ color: UIColor)
}


final class ThemeManager {
    
    
    //MARK: - Properties -
    
    
    static let shared = ThemeManager()
    private lazy var observers = [ThemeObserver]()

        
    var primaryColor: UIColor {
        
        get {

            UserDefaults.standard.colorForKey("primary_color") ?? colors[0]
        }
        
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: "primary_color")
            observers.forEach() { $0.didChangePrimaryColor(newValue) }
        }
    }
    
    
    var colors = [
        
        UIColor(red: 0.2525768876, green: 0.5986332893, blue: 0.5696017742, alpha: 1),
        UIColor(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1),
        UIColor(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
        UIColor(red: 0, green: 0.5603182912, blue: 0, alpha: 1),
        UIColor(red: 0.4662488699, green: 0.2868236005, blue: 0.9545490146, alpha: 1),
        UIColor(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    ]
    
    
    
    //MARK: - Methods -
    
    
    func addObserver(_ observer: ThemeObserver) {
        
        observers.append(observer)
    }
    
    
    func removeObserver(_ observer: ThemeObserver) {
        
        if let index = observers.firstIndex(where: { $0 === observer }) {
            
            observers.remove(at: index)
        }
    }
}
