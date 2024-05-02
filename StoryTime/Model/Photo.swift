//
//  Photo.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/28/24.
//

import Foundation
import FirebaseFirestore


struct Photo:Identifiable, Codable {
    var id: String
    var url: String
    var classification: String
    var uploadedAt: Date?
    var location: Location
    var address: String
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
}
