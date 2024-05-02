//
//  ContentView.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/28/24.
//

import SwiftUI
import FirebaseAuth


struct ContentView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State var darkMode : Bool = true
    @EnvironmentObject var darkModeViewModel : DarkModeViewModel
    
    
    
    var body: some View {
        Group{
            if (userViewModel.isLoggedIn){
                MainTabView()
            }
            else {
                SplashPage()
            }
        }
        .preferredColorScheme(darkModeViewModel.darkMode ? .dark : .light)
        

    }

}

#Preview {
    NavigationStack{
        ContentView()
    }
    .environmentObject(UserViewModel())
    .environmentObject(DayViewModel())
    .environmentObject(LocationViewModel())
    .environmentObject(DarkModeViewModel())

}
