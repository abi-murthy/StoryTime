//
//  PhotoRowView.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/30/24.
//

import Foundation
import SwiftUI


struct PhotoRowCell : View {
    let photo: Photo
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: photo.url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fill)
            .frame(height: 200)
            .clipped()

            Text(photo.classification)
                .font(.headline)
            Text("Uploaded at: \(photo.uploadedAt!.formatted())")
                .font(.subheadline)
            Text("Address: \(photo.address)")
                .font(.subheadline)

        }
        .padding(.vertical)
    }
}
