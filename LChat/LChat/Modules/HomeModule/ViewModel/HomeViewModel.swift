//
//  HomeViewModel.swift
//  LingoChat
//
//  Created by Егор on 02.03.2021.
//

import Foundation

protocol HomeViewModelProtocol {
    
    func search()
}


class HomeViewModel: HomeViewModelProtocol {
    
    let navigator: ChatNavigator
    
    init(navigator: ChatNavigator) {
        self.navigator = navigator
    }
    
    func search() {
        navigator.navigate(to: .search, presented: false)
    }
}
