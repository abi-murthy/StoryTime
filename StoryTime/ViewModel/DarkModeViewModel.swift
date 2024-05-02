//
//  darkModeViewModel.swift
//  StoryTime
//
//  Created by Abi Murthy on 5/1/24.
//

import Foundation


class DarkModeViewModel : ObservableObject {
    @Published var darkMode: Bool = true
    let MY_KEY = "darkmode"

    
    init() {
        let value = UserDefaults.standard.string(forKey: MY_KEY)
        if let value {
            darkMode = Bool(value)!
        }
    }
    
    func setMode(darkMode: Bool){
        UserDefaults.standard.set(darkMode.description, forKey: MY_KEY)
        self.darkMode = darkMode
    }
    
}
