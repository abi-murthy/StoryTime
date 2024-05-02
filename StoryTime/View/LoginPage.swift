//
//  LoginPage.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/29/24.
//

import Foundation
import SwiftUI

struct LoginPage: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var presentationMode
    

    var body: some View {
        NavigationView {
            VStack {
                Text("Login to your account")
                    .font(.title2)
                    .fontWeight(.bold)
                TextField("Email", text: $email)
                    .padding()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .border(Color.gray, width: 0.5)
                    .padding()

                SecureField("Password", text: $password)
                    .padding()
                    .border(Color.gray, width: 0.5)
                    .padding()

                Button("Login") {
                    do {
                        Task {
                            await userViewModel.signIn(email: email, password: password)
                        }
                    }
                }
                .padding()
                
                if let errorMessage = userViewModel.errorMessage {
                    Text(errorMessage)
                }

                Spacer()
                
                NavigationLink("Don't have an account? Sign up", destination: SignUpPage())
                    .padding()
                Spacer()
            }
            .navigationTitle("Login")
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
        LoginPage()
    }
    .environmentObject(UserViewModel())
    .environmentObject(DayViewModel())

    
}
