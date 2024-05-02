//
//  DayViewModel.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/29/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

class DayViewModel: ObservableObject {
    @Published var days: [Day] = []
    private let db = Firestore.firestore()
    private var userId = Auth.auth().currentUser?.uid
    @Published var currentDay: Day?
    
    init() {
        if userId != nil {
            loadDays()
        } else {
            return
        }
        
    }
    
    private func setCurrentDay() {
        let todayStart = Calendar.current.startOfDay(for: Date())
        self.currentDay = days.first { $0.date != nil && $0.date! >= todayStart }
    }
    

    func loadDays() {
        db.collection("users").document(userId!).collection("days")
            .order(by: "date", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.days = querySnapshot.documents.compactMap { document -> Day? in
                        try? document.data(as: Day.self)
                    }
                    self.setCurrentDay()
                    
                } else if let error = error {
                    print("Error getting days: \(error)")
                }
            }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            completion(.failure(NSError(domain: "Image Conversion Error", code: 0, userInfo: nil)))
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        
        let photoRef = storageRef.child("photos/\(Auth.auth().currentUser!.uid)/\(UUID().uuidString).jpg")
        
        photoRef.putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error ?? NSError(domain: "Firebase Upload Error", code: 0, userInfo: nil)))
                return
            }
            
            photoRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error ?? NSError(domain: "Firebase URL Error", code: 0, userInfo: nil)))
                    return
                }
                
                completion(.success(downloadURL.absoluteString))
            }
        }
    }

    func addPhotoToDay(image: UIImage, classification: String, location: Location, address: String) {
        uploadImage(image) { [weak self] result in
            switch result {
                case .success(let url):
                    let photo = Photo(id: UUID().uuidString, url: url, classification: classification, uploadedAt: Date(), location: location, address: address)
                    self?.addOrUpdatePhoto(with: photo)
                case .failure(let error):
                    print("Error uploading image: \(error)")
            }
        }
    }
    
    func addOrUpdatePhoto(with photo: Photo) {
        let todayStart = Calendar.current.startOfDay(for: Date())
        if let dayIndex = days.firstIndex(where: {
            guard let dayDate = $0.date else { return false }
            return dayDate >= todayStart
        }) {
            print("found day, adding photo into existing day")
            updateDayWithPhoto(photo: photo, atIndex: dayIndex)
        } else {
            print("no found day, adding photo into new day")
            createDayWithPhoto(photo: photo)
        }
    }

    private func updateDayWithPhoto(photo: Photo, atIndex index: Int) {
        var day = days[index]
        day.photos.append(photo)
        if day.id == currentDay?.id {
            currentDay = day
        }
        
        db.collection("users").document(userId!).collection("days").document(day.id!)
            .updateData([
                "photos": FieldValue.arrayUnion([try! Firestore.Encoder().encode(photo)])
            ])
    }

    private func createDayWithPhoto(photo: Photo) {
        let dayCollectionRef = db.collection("users").document(userId!).collection("days")

        let newDay = Day(story: "No story generated yet", photos: [photo])
        
        do {
            let data = try Firestore.Encoder().encode(newDay)
            let _ = dayCollectionRef.addDocument(data: data) { error in
                if let error = error {
                    print("Error creating new day with photos: \(error.localizedDescription)")
                } else {
                    print("Day document successfully creayed with nested photos.")
                }
            }
        } catch let error {
            print("Error encoding day or creating document: \(error.localizedDescription)")
        }
    }
    
    func addStoryToDay(story: String){ //public functoin to add story to current day
        let todayStart = Calendar.current.startOfDay(for: Date())
        if let dayIndex = days.firstIndex(where: {
            guard let dayDate = $0.date else { return false }
            return dayDate >= todayStart
        }) {
            print("found day, adding story into existing day")
            print(story)
            updateDayWithStory(story: story, atIndex: dayIndex)
        } else {
            print("no found day, nowhere to add this story")
        }
    }
    
    private func updateDayWithStory(story:String, atIndex index: Int){ //funciton to add story to a day after generatin, internal to find which day is needed to be updated
        var day = days[index]
        day.story = story
        if day.id == currentDay?.id {
            currentDay = day
        }
        
        db.collection("users").document(userId!).collection("days").document(day.id!)
            .updateData([
                "story": story
            ])
    }
    
}
