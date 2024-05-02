//
//  ProfilePage.swift
//  StoryTime
//
//  Created by Abi Murthy on 5/1/24.
//

import Foundation
import SwiftUI

struct ProfilePage : View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State var darkMode = true
    @EnvironmentObject var darkModeViewModel : DarkModeViewModel

    
    var body: some View{
        VStack{
            Text("Profile Page")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.semibold)
            Spacer()
            Image(systemName: "person.fill.and.arrow.left.and.arrow.right")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Spacer()

            VStack(alignment: .leading){
                
                
                if let user = userViewModel.currentUser{
                    Text("Welcome, \(user.username)")
                } else {
                    Text("not logged in")
                }
                    
                Toggle(isOn: $darkMode){
                    Text("Switch to \(darkMode ? "light" : "dark") mode")
                }
                .onAppear(){
                    let MY_KEY = "darkmode"
                    let value = UserDefaults.standard.string(forKey: MY_KEY)
                    if let value {
                        darkMode = Bool(value)!
                    }
                }
                .onChange(of: darkMode){
                    darkModeViewModel.setMode(darkMode: darkMode)

                }
                
            }
            .padding(20)

            
            Spacer()


            Button("Logout"){
                userViewModel.logout()
            }
        }
    }
}

#Preview {
    NavigationStack{
        ProfilePage()
    }
    .environmentObject(UserViewModel())
    .environmentObject(DayViewModel())
    .environmentObject(DarkModeViewModel())

    
}
