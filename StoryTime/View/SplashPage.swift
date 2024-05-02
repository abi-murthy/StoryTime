//
//  SplashPage.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/29/24.
//

import Foundation
import SwiftUI

struct SplashPage: View {
    
    @State var scale = 1.2
    @State private var changeColor = false

    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    let gradient = LinearGradient(colors: [.red, .orange],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [randomDarkColor(), randomDarkColor()]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true), value: changeColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("StoryTime")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .foregroundStyle(.white)
                    .scaleEffect(scale)
                    .onAppear{
                        withAnimation(
                            .easeInOut(duration: 5)
                            .repeatForever()
                        ) {
                            scale = 1.4
                        }
                    }
                
                    
 
                
                Spacer()

                VStack{
                    Text("Photo journaling with a helping hand!")
                        .padding()
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)

                    Image(systemName: "book.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.indigo)
                }
                .animation(nil, value: changeColor)
                .animation(nil, value: scale)


                
                Spacer()

                HStack(spacing: 30){
                    NavigationLink(destination: LoginPage()) {
                        Text("Login")
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.indigo, lineWidth: 2)
                            }
                    }
                    
                    NavigationLink(destination: SignUpPage()) {
                        Text("Sign Up")
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.indigo, lineWidth: 2)
                            }
                    }
                    
                }
                .animation(nil, value: scale)
                
                
                
                Spacer()
            }
            .padding(.top, 50)
        }
        .onReceive(timer) { _ in
            changeColor.toggle()
        }
    }
    
    func randomDarkColor() -> Color {
            let colors = [
                Color(red: 0.1, green: 0.2, blue: 0.3),
                Color(red: 0.1, green: 0.1, blue: 0.2),
                Color(red: 0.2, green: 0.1, blue: 0.3),
                Color(red: 0.1, green: 0.2, blue: 0.1),
                Color(red: 0.05, green: 0.2, blue: 0.2)
            ]
            return colors.randomElement() ?? Color.black
        }
}

#Preview {
    NavigationStack{
        SplashPage()
            
    }
    .environmentObject(UserViewModel())
    .environmentObject(DayViewModel())

}
