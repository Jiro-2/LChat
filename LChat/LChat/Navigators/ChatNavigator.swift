//
//  ChatNavigator.swift
//  LingoChat
//
//  Created by Егор on 13.02.2021.
//

import UIKit

final class ChatNavigator: Navigator {
    
    //MARK: Properties
    
    private weak var navigationController: UINavigationController?
    
    enum Destination {
        case search
        case chat
        case chatList
    }
    
    
    //MARK: - Init
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    
    //MARK: - Public Methods
    
    func navigate(to destination: Destination, presented: Bool) {
        
        let viewController = makeViewController(for: destination)
        
        presented ? navigationController?.present(viewController, animated: true, completion: nil) : navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //MARK: - Private methods
    
    private func makeViewController(for destination: Destination) -> UIViewController {
     
        switch destination {
        
        case .search:
            
            let viewController = MainAssembler.buildSearchUserModule(navigator: self)
            return viewController
            
        case .chat:
            
            let viewController = MainAssembler.buildChatModule()
            return viewController
            
        case .chatList:
            
            let viewController = MainAssembler.buildChatListModule(navigator: self)
            return viewController
        }
    }
}
