//
//  UserViewModel.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/29/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn = false
    @Published var errorMessage: String?

    func signUp(email: String, username: String, password: String) async {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let newUser = User(id: authResult.user.uid, email: email, username: username)

            let _ = try Firestore.firestore().collection("users").document(newUser.id).setData(from: newUser)
            DispatchQueue.main.async {
                self.currentUser = newUser
                self.isLoggedIn = true
                self.errorMessage = "" //sign up funciton to signup user, will automatixclaly log them and also has error messages
            }

        } catch {
            print("Error during sign up: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to create account: \(error.localizedDescription)"
            }
        }
    }

    func signIn(email: String, password: String) async {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let docRef = Firestore.firestore().collection("users").document(authResult.user.uid) // also gets user model from firestore
            let user = try await docRef.getDocument(as: User.self)
            DispatchQueue.main.async {
                self.currentUser = user
                self.isLoggedIn = true //sign in funciton to signup user, will automatixclaly log them and also has error messages
                self.errorMessage = ""
            }

        } catch {
            print("Error during sign in: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to sign in: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            } //logs user out
        }
        catch {
            print("Error during sign out: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
            }
        }
    }
}
