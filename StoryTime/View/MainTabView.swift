//
//  MainTabView.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/30/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @StateObject var dayViewModel : DayViewModel = DayViewModel()


    var body: some View {
        TabView {
            PhotoUploadView()
                .tabItem {
                    Label("Add Photo", systemImage: "camera")
                }
            CurrentDayView()
                .tabItem {
                    Label("Today's Photos", systemImage: "photo.on.rectangle.angled")
                }
            AllDaysView()
                .tabItem {
                    Label("All Days", systemImage: "calendar.badge.clock")
                }
            ProfilePage()
                .tabItem{
                    Label("Profile Page", systemImage: "person.crop.square.badge.camera")
                }
        }
        .environmentObject(dayViewModel)
        
    }

}

#Preview {
    NavigationStack{
        MainTabView()
    }
    .environmentObject(UserViewModel())
    .environmentObject(DarkModeViewModel())
    .environmentObject(DayViewModel())


}
