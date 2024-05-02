//
//  SignUpPage.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/29/24.
//

import Foundation

import SwiftUI

struct SignUpPage: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword = ""
    @Environment(\.presentationMode) var presentationMode

    
    @State private var changeColor = false

    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let gradientAnimation = Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)
    
    var disabled: Bool {
            email.isEmpty || username.isEmpty || password.isEmpty || password != confirmPassword
        }

    var body: some View {
        
        NavigationView{
            VStack(spacing: 20) {
                Spacer()

                Text("Create your account")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .padding()
                    .autocapitalization(.none)
                    .border(Color.gray, width: 0.5)
                    .padding()
                
                
                TextField("Username", text: $username)
                    .padding()
                    .autocapitalization(.none)
                    .border(Color.gray, width: 0.5)
                    .padding()
                
                SecureField("Password", text: $password)
                    .padding()
                    .border(Color.gray, width: 0.5)
                    .padding()
                
                SecureField("Password", text: $confirmPassword)
                    .padding()
                    .border(Color.gray, width: 0.5)
                    .padding()
                
                Button() {
                    Task {
                        await userViewModel.signUp(email: email, username: username, password: password)
                    }
                } label : {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(disabled ? Color.gray : Color.indigo)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(disabled)
                
                if let errorMessage = userViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                Spacer()
                NavigationLink("Have an account? Log in", destination: LoginPage())
                    .padding()
                Spacer()
                
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .navigationTitle("Signup")
            .navigationBarHidden(true)
            .onChange(of: userViewModel.isLoggedIn, {
                if userViewModel.isLoggedIn {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            
        }
            
    }
     
    
}

#Preview {
    NavigationStack{
        SignUpPage()
    }
    .environmentObject(UserViewModel())
    .environmentObject(DayViewModel())


}
