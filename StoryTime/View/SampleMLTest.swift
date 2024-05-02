//
//  SampleMLTest.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/28/24.
//

import Foundation
import SwiftUI

struct SampleMLTest: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @StateObject private var viewModel = ImageClassificationViewModel()
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)
            }
            
            Text(viewModel.classificationLabel)
                .padding()
                .foregroundColor(viewModel.classificationLabel.isEmpty ? .gray : .black)

            Button("Select Image") {
                isImagePickerPresented = true
            }
            .padding()
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, didCancel: {
                    isImagePickerPresented = false
                }, didFinishPicking: { image in
                    isImagePickerPresented = false
                    self.selectedImage = image
                    viewModel.classifyImage(image)
                })
            }
            
            Button("Logout"){
                userViewModel.logout()
            }
        }
    }
}



#Preview{
    SampleMLTest()
        .environmentObject(UserViewModel())
}
