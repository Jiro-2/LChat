import UIKit

protocol SettingsViewModelProtocol {

    var isDarkStyle: Bindable<Bool> { get set }
    var colors: [UIColor] { get }
    var primaryColor: Bindable<UIColor> { get set }
    var indexPrimaryColor: Int { get }
    
    func setPrimaryColor(_ color: UIColor)
    func changeAppTheme(_ isDarkTheme: Bool)
}


final class SettingsViewModel: SettingsViewModelProtocol {
    
    //MARK: - Property -
    
    var isDarkStyle = Bindable<Bool>()
    var primaryColor = Bindable<UIColor>()
    let colors = ThemeManager.shared.colors
    
    var indexPrimaryColor: Int {
        
        get {
            
             colors.firstIndex(where: { $0 == primaryColor.value }) ?? 0
        }
    }
    
    //MARK: - Init -
    
    
    init() {
        
        if UserDefaults.standard.interfaceStyle == .dark {
            
            isDarkStyle.value = true
            
        } else {
            
            isDarkStyle.value = false
        }
        
        primaryColor.value = ThemeManager.shared.primaryColor
    }
    
    
    //MARK: - Methods -
    
    
    func changeAppTheme(_ isDarkTheme: Bool) {
        
        if isDarkTheme {
    
            UserDefaults.standard.interfaceStyle = .dark
            isDarkStyle.value = true
            
        } else {
            
            UserDefaults.standard.interfaceStyle = .light
            isDarkStyle.value = false
        }
    }
    
    
    func setPrimaryColor(_ color: UIColor) {
        
        ThemeManager.shared.primaryColor = color
    }
}
