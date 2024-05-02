//
//  StoryTimeApp.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/28/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct StoryTimeApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var userViewModel : UserViewModel = UserViewModel()
    @StateObject var locationViewModel = LocationViewModel()
    
    @StateObject var darkModeViewModel : DarkModeViewModel = DarkModeViewModel()


    
    var body: some Scene {
        
        WindowGroup {
            NavigationStack{
                ContentView()
            }
            .environmentObject(userViewModel)
            .environmentObject(locationViewModel)
            .environmentObject(darkModeViewModel)
        }
    }
}
