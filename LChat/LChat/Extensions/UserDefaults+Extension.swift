import UIKit

extension UserDefaults {
    
    func set(_ color: UIColor, forKey key: String) {
        
        do {
            
            let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(colorData, forKey: key)
            
        } catch let error {
            
            assertionFailure(error.localizedDescription)
        }
    }
    
    
    
    func colorForKey(_ key: String) -> UIColor? {
        
        var returnColor: UIColor?
        
        if let colorData = data(forKey: key) {
            
            do {
                
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
                
                    returnColor = color
                
                }
                
            } catch let error {
                
                assertionFailure(error.localizedDescription)
            }
        }
        
        return returnColor
    }
}





extension UserDefaults {
    
    var interfaceStyle: UIUserInterfaceStyle {
        
        get {
            
            UIUserInterfaceStyle.init(rawValue: integer(forKey: "interface_style")) ?? .unspecified
        }
        
        set {
            
            set(newValue.rawValue, forKey: "interface_style")
        }
    }
}


