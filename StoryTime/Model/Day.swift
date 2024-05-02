//
//  Day.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/28/24.
//

import Foundation
import FirebaseFirestore

struct Day: Codable {
    @DocumentID var id: String?  
    @ServerTimestamp var date: Date?
    var story: String
    var photos: [Photo]
}
