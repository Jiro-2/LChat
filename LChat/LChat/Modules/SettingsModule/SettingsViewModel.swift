
import UIKit

protocol SettingsViewModelProtocol {

    var isDarkStyle: Bindable<Bool> { get set }

    func changeAppTheme(_ isDarkTheme: Bool)
}


final class SettingsViewModel: SettingsViewModelProtocol {
    
    //MARK: - Property -
    
    var isDarkStyle = Bindable<Bool>()
    
    
    //MARK: - Init -
    
    
    init() {
        
        if UserDefaults.standard.interfaceStyle == .dark {
            
            isDarkStyle.value = true
            
        } else {
            
            isDarkStyle.value = false
        }
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
}
