//
//  User.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/28/24.
//

import Foundation
import FirebaseFirestore


struct User: Identifiable, Codable {
    var id: String  // Corresponds to userId in Firestore
    var email: String
    var username: String
    @ServerTimestamp var created: Date?
    var days: [Day]?
}
