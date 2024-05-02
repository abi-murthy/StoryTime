//
//  PhotosMapView.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/30/24.
//

import Foundation
import SwiftUI
import MapKit


struct PhotosMapView: View {
    var photos: [Photo]
    
    
    var body: some View {
            Map() {
                ForEach(photos, id: \.id) {photo in
                    Annotation(photo.classification, coordinate: CLLocationCoordinate2D(latitude: photo.location.latitude, longitude: photo.location.longitude)) {
                        Circle()
                            .foregroundStyle(.teal)
                            .frame(width: 10.0)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 300, idealHeight: 400, maxHeight: 500)
            .mapStyle(.imagery)
        }
}

#Preview {
    PhotosMapView(photos: [
        Photo(id: UUID().uuidString, url: "hehe", classification: "monkey", uploadedAt: Date(), location: Location(latitude: 34, longitude: 34), address: "ur mom"),
        Photo(id: UUID().uuidString, url: "hoho", classification: "donkey", uploadedAt: Date(), location: Location(latitude: 34.001, longitude: 34),address: "ur mom"),
        Photo(id: UUID().uuidString, url: "hehe", classification: "conkey", uploadedAt: Date(), location: Location(latitude: 34.0022, longitude: 34),address: "ur mom"),
    ])
}
