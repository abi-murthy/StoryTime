//
//  StoryViewModel.swift
//  StoryTime
//
//  Created by Abi Murthy on 4/30/24.
//

import Foundation
import FirebaseFunctions

class StoryViewModel: ObservableObject {
    @Published var story: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func generateStory(with photos: [Photo], completion: @escaping (String) -> Void) {
        guard !photos.isEmpty else {
            self.story = "No photos available to generate a story."
            return
        }
        isLoading = true
        let prompt = constructPrompt(from: photos)
        
        fetchStory(prompt: prompt) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let generatedStory):
                    self?.story = generatedStory
                    self?.errorMessage = ""
                    completion(generatedStory)
                case .failure(let error):
                    self?.errorMessage = "Failed to generate story: \(error.localizedDescription)"
                    completion("Failed to generate story")
                }
            }
        }
    }

    private func constructPrompt(from photos: [Photo]) -> String {
//        var prompt = "Write a funny story based on these photo details. Make it chronological, and include all the times, addresses, and objects in the photo. Be creative!:\n"
        var prompt = ""
        for photo in photos {
            if let uploadedAt = photo.uploadedAt {
                let dateStr = DateFormatter.localizedString(from: uploadedAt, dateStyle: .medium, timeStyle: .short)
                prompt += "- Photo of a \(photo.classification) taken on \(dateStr) at \(photo.address).\n"
            } else {
                prompt += "- Photo of a \(photo.classification) at location \(photo.address).\n"
            }
        }
        return prompt
    }

    func fetchStory(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let functions = Functions.functions()
        functions.httpsCallable("generateStory").call(["prompt": prompt]) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let storyData = result?.data as? [String: Any], let story = storyData["story"] as? String {
                completion(.success(story))
            } else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
            }
        }
    }
    
    func clearStory(){
        story = ""
    }
    
    
}
