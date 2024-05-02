//
//  PhotoUploadView.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/29/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct PhotoUploadView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var dayViewModel: DayViewModel
    @StateObject private var viewModel = ImageClassificationViewModel()
    @EnvironmentObject var locationViewModel : LocationViewModel
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var address: String = ""
    
    var body: some View {
        
        Form {
            if let _ = locationViewModel.lastKnownLocation {
                
            } else {
                Button("Give us location access to generate coordinates") {
                    locationViewModel.requestPermission()
                }
            }

            Section(header: Text("Photo")) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } else {
                    Button("Select Photo") {
                        isImagePickerPresented = true
                    }
                }
            }
            
            Section(header: Text("Coordinates")) {
                TextField("Latitude", text: $latitude)
                    .keyboardType(.numbersAndPunctuation)
                TextField("Longitude", text: $longitude)
                    .keyboardType(.numbersAndPunctuation)
                Button("Add current location"){
                    if let location = locationViewModel.lastKnownLocation {
                        latitude = "\(location.coordinate.latitude)"
                        longitude = "\(location.coordinate.longitude)"
                    }
                }
            }
            
            
            
            Section(header: Text("Classification")) {
                Text(viewModel.classificationLabel.isEmpty ? "No classification" : viewModel.classificationLabel)
            }
            Section(header: Text("Address")) {
                TextField("Address", text: $address)
                Button("Fetch Address") {
                    reverseGeocode(latitude: Double(latitude)!, longitude: Double(longitude)!) { address in
                        self.address = address
                    }
                }
                .disabled(latitude == "" || longitude == "")
                
            }

            Button("Upload Photo") {
                handleUpload()
            }
            .disabled(selectedImage == nil || latitude.isEmpty || longitude.isEmpty || address.isEmpty)
            
        }
        .navigationTitle("Upload Photo")
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, didCancel: {
                isImagePickerPresented = false
            }, didFinishPicking: { image in
                isImagePickerPresented = false
                self.selectedImage = image
                viewModel.classifyImage(image)
                if let location = locationViewModel.lastKnownLocation {
                    latitude = "\(location.coordinate.latitude)"
                    longitude = "\(location.coordinate.longitude)"
                }
            })
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Upload Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
            
        
        
        
    }
    
    private func handleUpload() {
        guard let image = selectedImage,
              let lat = Double(latitude),
              let lon = Double(longitude),
              address != ""
        else {
            alertMessage = "Invalid data. Please check the inputs."
            showingAlert = true
            return
        }
        
        let location = Location(latitude: lat, longitude: lon)
        let classification = viewModel.classificationLabel
        
        dayViewModel.addPhotoToDay(image: image, classification: classification, location: location, address: address)
        alertMessage = "Added photo"
        showingAlert = true
        selectedImage = nil
        latitude = ""
        longitude = ""
        address = ""
        viewModel.clearClassification()
    }
}

#Preview {
    NavigationStack{
        PhotoUploadView()
    }
    .environmentObject(UserViewModel())
    .environmentObject(DayViewModel())
    .environmentObject(LocationViewModel())
}
